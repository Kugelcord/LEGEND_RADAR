function loadRadar()
    print("[Legend System] Radar was successfully loaded")
end

function checkUpdates()
    local url = "https://api.github.com/repos/Kugelcord/legend_radar/releases/latest"

    PerformHttpRequest(url, function(statusCode, resultData, headers)
        if statusCode == 200 then
            local release = json.decode(resultData)
            local latestVersion = release.tag_name

            -- Vergleiche die aktuelle Version mit der auf GitHub verfügbaren Version
            if latestVersion ~= nil and latestVersion ~= CURRENT_VERSION then
                print("[Legend System] New version available: " .. latestVersion)
            else
                print("[Legend System] Your version is up to date.")
            end
        else
            print("[Legend System] Failed to check for updates.")
        end
    end, "GET", "", {["Accept"] = "application/json"})
end

local CURRENT_VERSION = "1.0"

loadRadar()
checkUpdates()
