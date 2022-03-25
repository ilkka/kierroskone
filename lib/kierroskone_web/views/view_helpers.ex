defmodule KierroskoneWeb.ViewHelpers do
  def humanize_laptime(laptime) do
    {_h, min, sec, usec} =
      Timex.Duration.from_milliseconds(laptime.milliseconds) |> Timex.Duration.to_clock()

    "#{min}:#{sec |> Integer.to_string() |> String.pad_leading(2, "0")}.#{floor(usec / 1000) |> Integer.to_string() |> String.pad_leading(3, "0")}"
  end
end
