import os

import ac
import acsys
import datetime
import configparser
from urllib import request  # Using this stupid built-in thing for avoiding deps
import json
from os.path import exists
import threading

kierroskone = None
title = "Kierroskone"

telemetry_keys = ['AccG', 'Aero', 'BestLap', 'Brake', 'CGHeight', 'CamberDeg', 'CamberRad', 'Caster',
                  'Clutch', 'CurrentTyresCoreTemp', 'DY', 'DriftBestLap', 'DriftLastLap', 'DriftPoints',
                  'DriveTrainSpeed', 'DrsAvailable', 'DrsEnabled', 'DynamicPressure', 'ERSCurrentKJ', 'ERSDelivery',
                  'ERSHeatCharging', 'ERSMaxJ', 'ERSRecovery', 'EngineBrake', 'Gas', 'Gear',
                  'InstantDrift', 'IsDriftInvalid', 'IsEngineLimiterOn', 'KersCharge', 'KersInput', 'LapCount',
                  'LapInvalidated', 'LapTime', 'LastFF', 'LastLap', 'LastTyresTemp', 'Load', 'LocalAngularVelocity',
                  'LocalVelocity', 'Mz', 'NdSlip', 'NormalizedSplinePosition', 'P2PActivations', 'P2PStatus',
                  'PerformanceMeter', 'RPM', 'RaceFinished', 'RideHeight', 'SlipAngle', 'SlipAngleContactPatch',
                  'SlipRatio', 'SpeedKMH', 'SpeedMPH', 'SpeedMS', 'SpeedTotal', 'Steer', 'SuspensionTravel',
                  'ToeInDeg', 'TurboBoost', 'TyreContactNormal', 'TyreContactPoint', 'TyreDirtyLevel',
                  'TyreHeadingVector', 'TyreLoadedRadius', 'TyreRadius', 'TyreRightVector', 'TyreSlip',
                  'TyreSurfaceDef', 'TyreVelocity', 'Velocity', 'WheelAngularSpeed', 'WorldPosition']


def log(msg):
    global title
    ac.log(title + ': ' + msg)


def read_car_name(car_id):
    # ../../../content/cars/{car_id}/ui/ui_car.json
    json_path = os.path.join(os.path.dirname(__file__), '..', '..', '..',
                             'content', 'cars', car_id, 'ui', 'ui_car.json')
    log("Getting car data from " + json_path)
    with open(json_path) as json_file:
        car_data = json.load(json_file, strict=False)
        return car_data["name"]  # also class available


def read_track_name(track_id, layout_id):
    # ../../../content/tracks/{track_id}/ui/{layout_id}/ui_track.json
    json_path = os.path.join(os.path.dirname(__file__), '..', '..', '..',
                             'content', 'tracks', track_id, 'ui', layout_id, 'ui_track.json')
    log("Getting car data from " + json_path)
    with open(json_path) as json_file:
        track_data = json.load(json_file, strict=False)
        return track_data["name"]  # also class available


def ms_to_min(ms_time):
    seconds, milliseconds = divmod(ms_time, 1000)
    minutes, seconds = divmod(seconds, 60)

    return (format(minutes, '01') + ":" + format(seconds, '02') + "." + format(milliseconds, '03'))


class Kierroskone:
    def __init__(self):
        global title
        self.timer = 0
        self.title = title
        self.base_dir = 'apps/python/' + title
        self.config_ini = self.base_dir + '/config.ini'
        self.config_header = 'SETTINGS'
        self.update_interval = 0.5  # seconds
        self.app = None
        self.label_current_best = None
        self.server = ""
        self.apitoken = ""
        self.lap_top_speed = 0
        self.current_lap = 0
        self.current_best = 0
        self.status_text = "Waiting for hot laps"
        self.label_state = None
        self.telemetry_enabled = False
        self.telemetry_store = []

        try:
            if exists(self.config_ini):
                self.parse_config()
            else:
                log("No config file found")

            self.car = read_car_name(ac.getCarName(0))
            track_id = ac.getTrackName(0)
            layout_id = ac.getTrackConfiguration(0)

            self.track = read_track_name(track_id, layout_id)

            log(self.car)
            log(self.track)
            log(layout_id)

            self.build_ui()

            # log("Logging now acsys")
            # log(str(dir(acsys)))
            # log(str(dir(acsys.CS)))

        except Exception as error:
            log(str(error))

    def build_ui(self):
        def add_label(app, row, column, alignment, text):
            log("Added label " + text)
            new_label = ac.addLabel(app, text)
            x_coord = 5 + column * 100
            y_coord = (row + 1) * 30
            ac.setPosition(new_label, x_coord, y_coord)
            ac.setSize(new_label, 50, 16)
            ac.setFontSize(new_label, 16)
            ac.setFontAlignment(new_label, alignment)
            return new_label

        # Build the window
        log("Building the UI")
        self.app = ac.newApp(self.title)
        ac.setSize(self.app, 400, 250)
        ac.setTitle(self.app, 'Kierroskone')
        ac.drawBorder(self.app, 0)
        ac.drawBackground(self.app, 1)
        ac.setBackgroundOpacity(self.app, 0.5)

        # Build all the UI components
        add_label(self.app, 0, 0, 'left', "Driving " + self.car + " at " + self.track)
        add_label(self.app, 1, 0, 'left', "Current best:")
        self.label_current_best = add_label(self.app, 1, 1, 'center', str(self.current_best))
        self.label_state = add_label(self.app, 3, 0, 'left', self.status_text)

    def parse_config(self):
        cfg = configparser.ConfigParser()
        cfg.read(self.config_ini)
        self.server = cfg[self.config_header].get('kierroskone_server', 'localhost')
        self.apitoken = cfg[self.config_header].get('kierroskone_apitoken', '')
        telemetry_flag = cfg[self.config_header].get('kierroskone_include_telemetry', 'false')
        self.telemetry_enabled = telemetry_flag == "true"
        log('Using server ' + self.server)

    def update(self, time_delta):
        global telemetry_keys
        self.timer += time_delta

        # Once every update_interval seconds
        if self.timer > self.update_interval:
            self.timer = 0

            # Current telemetry values
            lap = ac.getCarState(0, acsys.CS.LapCount)
            best_lap = ac.getCarState(0, acsys.CS.BestLap)
            speed = ac.getCarState(0, acsys.CS.SpeedKMH)

            telemetry_item = {}
            for key in telemetry_keys:
                telemetry_item[key] = ac.getCarState(0, getattr(acsys.CS, key))
            self.telemetry_store.append(telemetry_item)

            self.lap_top_speed = max(self.lap_top_speed, speed)
            # New lap started
            if lap > self.current_lap:
                self.status_text = "Waiting for hot laps"
                # best_lap stays 0 if first lap is dirty
                if best_lap != 0 and (best_lap < self.current_best or self.current_best == 0):
                    log('New best lap!')
                    self.current_best = best_lap
                    self.status_text = "Sending new best lap"
                    self.send_laptime_to_server()
                self.current_lap = lap
                self.lap_top_speed = 0
                self.telemetry_store = []
                self.draw()

    def send_request(self, event, url, json_payload, cb):
        log("New thread sending request")
        event.set()
        req = request.Request(url, data=json_payload, method="POST")
        req.add_header("Content-Type", "application/json")
        req.add_header("x-api-token", self.apitoken)
        try:
            with request.urlopen(req, timeout=5) as response:
                log("Request done")
                log(str(response.status))
                cb(True)
        except Exception as ex:
            # For some reason this never works
            log(ex)
            cb(False)

    def request_finished(self, success):
        if success:
            log("Request finished successfully")
            log(self.status_text)
            self.status_text = "New best lap stored"
            log(self.status_text)
        else:
            log("Request failed successfully")
            self.status_text = "Error connecting to server"
        self.draw()

    def send_laptime_to_server(self):
        url = self.server + "/api/laptime-import/assettocorsa"
        log("Saving laptime to server " + url)
        payload = [
            {
                "Track": self.track,
                "Car": self.car,
                "Date": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                "Time": ms_to_min(self.current_best),
                "Topspeed": str(self.lap_top_speed)
            }
        ]

        if self.telemetry_enabled:
            payload[0]["Telemetry"] = self.telemetry_store

        json_payload_str = json.dumps(payload)
        json_payload = str(json_payload_str).encode('utf-8')
        saved_path = os.path.join(os.path.dirname(__file__), "saved_request.json")
        log(saved_path)
        log(json_payload_str)
        with open(saved_path, "w") as request_file:
            request_file.write(json_payload_str)
        event = threading.Event()
        runner = threading.Thread(target=self.send_request, args=(event, url, json_payload, self.request_finished))
        runner.start()
        event.wait()

    def draw(self):
        ac.setText(self.label_current_best, ms_to_min(self.current_best))
        ac.setText(self.label_state, "State: " + self.status_text)

    def shutdown(self):
        log("Shutting down")


def acShutdown():
    global kierroskone
    if kierroskone is not None:
        kierroskone.shutdown()


def acMain(ac_version):
    global kierroskone, title
    kierroskone = Kierroskone()
    return title


def acUpdate(timeDelta):  # timeDelta in ms
    global kierroskone
    if kierroskone is not None:
        kierroskone.update(timeDelta)
    else:
        log("Kierroskone not initialized properly")
