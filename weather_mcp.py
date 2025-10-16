from __future__ import annotations

import httpx
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Weather Simple", port=8053, host="0.0.0.0")


@mcp.tool()
async def get_weather(city: str) -> dict:
    """
    Get current weather for a city using wttr.in (free, no API key).

    Returns a small dict with temperature, feels like, humidity, wind, and a text summary.
    """
    url = f"https://wttr.in/{city}?format=j1"
    async with httpx.AsyncClient(timeout=15) as client:
        r = await client.get(url)
        r.raise_for_status()
        data = r.json()

    cur = data["current_condition"][0]
    nearest = data.get("nearest_area", [{}])[0]
    out = {
        "city": nearest.get("areaName", [{"value": city}])[0]["value"],
        "country": nearest.get("country", [{"value": ""}])[0]["value"],
        "temp_c": float(cur["temp_C"]),
        "feels_like_c": float(cur["FeelsLikeC"]),
        "humidity_pct": int(cur["humidity"]),
        "wind_kmph": float(cur["windspeedKmph"]),
        "wind_dir": cur.get("winddir16Point"),
        "summary": cur.get("weatherDesc", [{"value": ""}])[0]["value"],
        "observation_time_utc": cur.get("observation_time"),
    }
    return out


if __name__ == "__main__":
    mcp.run(transport="streamable-http")