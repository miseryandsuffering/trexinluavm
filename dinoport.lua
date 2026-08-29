local B64_MAP = {}
local B64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
for i = 1, #B64_CHARS do
    B64_MAP[B64_CHARS:byte(i)] = i - 1
end

local function b64decode(str)
    str = str:gsub("[^%w%+%/%=]", "")
    local out = {}
    local len = #str
    local pad = 0
    if len >= 2 and str:sub(-2) == "==" then
        pad = 2
    elseif len >= 1 and str:sub(-1) == "=" then
        pad = 1
    end

    local validLen = len - (len % 4)
    local outIdx = 1

    for i = 1, validLen, 4 do
        local a = B64_MAP[str:byte(i)]     or 0
        local b = B64_MAP[str:byte(i + 1)] or 0
        local c = B64_MAP[str:byte(i + 2)] or 0
        local d = B64_MAP[str:byte(i + 3)] or 0

        local b1 = (a * 4) + math.floor(b / 16)
        local b2 = ((b % 16) * 16) + math.floor(c / 4)
        local b3 = ((c % 4) * 64) + d

        out[outIdx] = string.char(b1)
        outIdx = outIdx + 1

        if i + 4 > validLen and pad >= 2 then
            break
        end
        out[outIdx] = string.char(b2)
        outIdx = outIdx + 1

        if i + 4 > validLen and pad >= 1 then
            break
        end
        out[outIdx] = string.char(b3)
        outIdx = outIdx + 1
    end

    return table.concat(out)
end

-- ── Verified Distinct Sprites (Base64) ────────────────────────
local SPRITES_B64 = {
    trex_idle = "iVBORw0KGgoAAAANSUhEUgAAACwAAAAvCAYAAACYECivAAABMklEQVR4nOWZwQrDIBBEV/HgB+bo5+0x/xdvlpZIqcSocW0YMxBKiWzNY+pOtyqEQCPkvRctbK1V71dNYDKjyTrnuuox8897OMJK2sORcC/ZHOm/EV7X9XP1Cs4S5l8ftCyLSB04wprApAlMmsCkCUzm7g1w0nrnJeyT0BLj3Og46TItPJJP94FH2CdhpcVTR1RrQw83eheXMDWqh2qNSt8dOMJq27bDwF3y2KiAbmcjbHI3cqeGFFne67bWm4fwKK8+N0vcJduYWfAI2/0JmXnIAATeElzZIIobRiGtaZZhoBce6nFy3l61xDyEpUizEFlYwrqF1FnfL92XEhxhU1oQPZebO6SNIHeO207vzkt4VIu9qucQdt/ffOGMtKtcNy1hVfvHYmk6WTpNKFl3VXCEX8Kulmnc7hr8AAAAAElFTkSuQmCC",
    trex_run1 = "iVBORw0KGgoAAAANSUhEUgAAACwAAAAvCAYAAACYECivAAABI0lEQVR4nO2YwQ6DIBBEF8KBD/TI5+3R/5MbTRtJUyIFyqIZ7CTGGM2KLyM7oEIINELee9HC1lr1PGsCkxlN1jnXVY+ZP67hCCtpD0fCvWRzpE8jvK7r6+gVnCXMWS9alkWkDhxhTWDSBCZNYNIEJnP1ADhpvfMS9kloiXFudJx0mRYeyafjwCPsk7DS4qkjqrWhhxu9i0uYGtVDtUalfweOsNq27TBwlzw2KqDb2Qib3I3crCFFlve6rfXmITzKq/fNElfJNmYWPMJ2/0JmHrIBAm8JrmwQxQGjkNY0y2agF97U42S+/dUS8xCWIs1CZOcnXLvK/fYcC9Cej3DJy2kjqNmfsB0+hiNspFts7yxQ0n0Iu/eaL5xB9j6zRE5/wnSsB1P8l5MTJEvuAAAAAElFTkSuQmCC",
    trex_run2 = "iVBORw0KGgoAAAANSUhEUgAAACwAAAAvCAYAAACYECivAAABKElEQVR4nOWZQQrEIAxFo7jIAbv0eFn2fnXnMENlGKmoY9IS/VBKKaT28dWPMTFGkFAIgbUwIpr33YIyOWmy3vuhekT086yOsOH2cCI8SrZE+jbC+75/rlGps4S760PbtrHUUUfYgjJZUCYLymRBmdzTA6Bs652XcMhCS4pz0nHSF7bwRD4fhz7CIQsrPZ66otoaeqjTu3oJQ6dGqLaoNnfUETbHcVwG7prHpAI6zkbYlV6UVg0usnTW7a03D2Epr66bJZ4SdmYWfYTx/EMiEjkAUW8JatwgqgPWQtrCLIeBgflQj7L19l9LzEOYizQxkVVL2I2mK6k0Nw1h09oyqDVbSqRpcKNYx8N4EkqkS7Ofu6G4DuGkXi/6r5fjkuuwkWosloSrEX4BL+WXgNCtgfwAAAAASUVORK5CYII=",
    trex_dead = "iVBORw0KGgoAAAANSUhEUgAAACwAAAAvCAYAAACYECivAAABOUlEQVR4nOWZTQ6EIAyFC2HBAVlyvC65n+ycTKKZSAb5KzPzmLcxRlLxy7OtVe37TjMUYxQNbK1Vz6MmMJnZZL33Q/GY+XIOR1hJe/gkPEo2R1rcEjmFEC7nzrmuOB+1hHOue6OwHjafvFlIbPHTG3aDVoC1hCYwaQKTJjBpApPJNS1nO/etdpKPUpzuA49wTJqVtJ1rpVrb9HDDfbAJU6NGqNao9O7AEVbbtr1tuEsem9Wg29UIm9yFXNaQIstH3NZ46xCe5dXRfLwe4dmyjT0LHmF7PCEzTxmAwFuCKwtEccMopDWtMgyMwkM9TvJtryXWISxFmoXIwhLWLaTu6n7pupTgCJvSgtNzublDWghyedwOenddwrNKbK/+h7B/ffPtd6R95bplCavaH4ul6WQpm1CyrldwhB8E6ZZfNDlIFwAAAABJRU5ErkJggg==",
    duck1     = "iVBORw0KGgoAAAANSUhEUgAAADsAAAAeCAYAAACSRGY2AAAA/0lEQVR4nO2YUQ7DIAhAoeGIHpM72mTRZWESHcXqtO+nP7YgT0kVY4wRCiAiwmIQTIgmwAomce/JhhBeT2YuBpSmvRMqxVjabBQFzAKssBD3NVkZQDPtldBnjN4QTIhHAUtbk+4KfCVGTvZqLgdsBHo3hRnhtDL2MguJlQ3z1mZXNsyP2T8z/Ouf1wEbgbUBdxqWpqyxWHwnn6Yesy2WexjORrKJq2dmFOdjGtlM5KmkN2R5SUtSs22djPfNBbUM8rqC0ZandiU0ZLIatWUo9+BoqGWQV8OQaEXqVRyyvFTbg7MZHXoHNaoI5JGk1nB6NRorB2wEenyk1rges3A/JwJamEkG3o4oAAAAAElFTkSuQmCC",
    duck2     = "iVBORw0KGgoAAAANSUhEUgAAADsAAAAeCAYAAACSRGY2AAABAUlEQVR4nO2Z2w7DIAiGwfCIPibv6JJFl4bJbD1P/W96Uwv4CRGKzjkHESEiwmIimFAagFyhB/cJ1lr7fjJz1KAkXduhmI2lyTqxgQFArliA+wpWGtBI13LoaqO1CCZUjQ2MpSb1MlxiIzhb6ouBjYS1i8KMYn8y9iILXisT5q3JrkyYD9k/I/z05mVgI2HqhZ6EJalcWyy+E7qpQ/YO5RaEA5FAorRnRtEf08hiIruS1qKcRRrVXzmXE1jtyQXdeanFCOYqbSQ0JNinudZrk5oEi5UKhpR2pFsN3qhkcSr/NKdHEacRRkcN4E1pYZnxzqzp3KA0pXJt9v9DZrQDPfUCPHSRM0G8FmUAAAAASUVORK5CYII=",
    ptero1    = "iVBORw0KGgoAAAANSUhEUgAAAC4AAAAoCAYAAACB4MgqAAAAv0lEQVR4nO2Yyw6EIAxFb2/4RD6z/9jZ6EIyZnB4We1ZEinJaSkgEARB0BOp/dDM7DBRpHruCAinpFrTOeev46vME08zbiem7wLhFGk1rapYUeuE9xq3xpou+/wvpDFDbo3Lqu6hjXvDv/Gr9MqQbubfYxx/snpvEE6R1gCjzOtJ7e9d6Ln38VXkIoNlBsL4rNreCeO9TkipvLuE8dkvJMIpaVTg0W9RwimEUwinpN4BZ/1nId6Obcxaj7MW6s0H1LVTT5BdMtgAAAAASUVORK5CYII=",
    ptero2    = "iVBORw0KGgoAAAANSUhEUgAAAC4AAAAoCAYAAACB4MgqAAAAv0lEQVR4nO2YQQ7EIAhFP6RH9Jjc0dmMi5IYh1FJUN5Ko908vtQWmKR+gTOMoDz/Ptgsl1JecyIiOMC4zbjG2zzjdOP1x87hZZ4RFLJ2j4aIvOZ6Xe9bbZ5xWsZrx7SVXZlnBIVmTbcMW/fTpPn4Ga+LMu2VeUZQnlnTuyt0nHFqA+tXzCrTot7AI9qZiG/cilcX6lXoPuO7zUsn+/dm3Dvzou44aXyVeRlku5HGNbP/E2lwawxrPEmSJEkSGPgAjutz+5ruqg0AAAAASUVORK5CYII=",
    cact_s1   = "iVBORw0KGgoAAAANSUhEUgAAABEAAAAjCAYAAABy3+FcAAAArklEQVR4nO2WQQ6AIAwEoeHAI3leH9lbDUZII61S9MieQMzQ3WAxMnOwRER9MeccrffSE6CU0ueIyBYIZgBVdS4re4V4tQwhUdUShC67DeSGkMirgf7NhIzkpyF3j16B5jF4Ie5tFW2IoxVoun/ZvwSLiGezgq+A4LWDiH0su1ya9d2ktUioD+UOKzoz+QpKbXCBeNbWUIkE5Yf7ZQqyKtiQQTuTUdH6U9LuH+s0H3/SXmDvGLJbAAAAAElFTkSuQmCC",
    cact_s2   = "iVBORw0KGgoAAAANSUhEUgAAACIAAAAjCAYAAADxG9hnAAABH0lEQVR4nO2YwQ6DIAxAxXDgAzn6eRz5QG4sNUCgK2qRoVl4B5MyAy9tUabw3i81nHPpR6WUWNrIF6jOIY8ktm1LsTHGN8h4rXUKrLUgRc6xXpEAIM4zxJUAQuwvizxBs4ijswNjrKzdEnGhdEhmL8VR+rFEfi9bxGX9k8kU/YB740Aiib+vRxxvR/xGpFLzoayVmg/nfT3ytyL6fAuPEeHSS0RYa29NUD0GUOA3MiHz9cb9iQjGGIMPTLtMDDhSsqNEJI6Rz6OanOQu3uHoWBB6S0hmHyy9BHIJuEiYGM6jZwK9QLtLFNs3yHRb7AIgUGQ2lSZmZgmMyhD5QFNKiZ490CzyJFMEMzOCmRnBzIxgRO2LEfX/puVDDTFGzvEBX8+PVsZh9poAAAAASUVORK5CYII=",
    cact_s3   = "iVBORw0KGgoAAAANSUhEUgAAADMAAAAjCAYAAAA5dzKxAAABXUlEQVR4nN2ZTY6EIBCFHxUWHpClx2PJAd0xYQIGaRn5KcZOfRtDq9XvURShovLeo8ZxHOfNbdsUBuCIASAXWY2hamaCiH3fz7G1tlsMRwwA3hhzDpxzv7rvHqQWEYEwzmf5CY4YKIwE4tg3mxmlU2iN4RjEJTxlYtJQyoTveWfKTCk8X1IThs4lZdoNXcx3m2ESzoEvzbPWTC/cE0GrAj/BVGOfZlYEfmOp0hfVwDQEQRAEQRAEQRAEQeieh8tT8EpMcVpenpnB/qRK7FWGoW8xEhsu1WLIGHObOd1rIMFsJCcY8j3LLXWfurcuFprIUfH6eBrJ22gdxFlrP1rcHsoYqzcKd12K6lIzUczUH3DEGKkxZOhydtN4ZHZbsrwya1SKma2J8L5zrjlLnLsi4UW4t3eNf2bl9q7xAqu2d4IgCIIgCIIgCIIgCIJQf31sKn8b+dg0G6Nycr6N8QOeQutaEMSn1AAAAABJRU5ErkJggg==",
    cact_l1   = "iVBORw0KGgoAAAANSUhEUgAAABkAAAAyCAYAAACpgnCWAAABCUlEQVR4nO2X0QqFIAyGc3jh+3Xb4+0d252HhYKV6VZ2Dgf2QRQy/dvIf+ZijJMEIjoFhhCcZK6XCizLchpHxCgRgrsCDI/XMlSLjABMRIOVS4VoM2qgYt/kjTpUhA4bNzsClAH5GiFQOoJvvcE0CGi9wTCR6QuAiWiwcqmwcv1ZuUjoX9SJc+u6Xh7enoKIW+N6rVyYBPgZ+IEH3hJgtkxGCuFBgHHlr0PrcN1atKTWUXcHiZTR6UvpCYdOq/a9CSPaMDxdQIKJqLByqbBy/a5cdGFB0ArW+BYlB6/N8VfB7MYa2w/JwWuOvOsnpRAHSzMJvb8yFrl78SFknufI91ZcNRMNOetWzAe4sfY1Bda2KAAAAABJRU5ErkJggg==",
    cact_l2   = "iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAABeklEQVR4nN2awY6DMAxEJyMf+D+ufF7+kdyyirSs2BZKQhyj+kmoEkoz2NhDggg5Z9SQUnobOE1TgCKpQ0NqBZZleTsfY8xawfRq8K5AoZw/ymIrGhqEEwgniKXYvkS0jUJgxGsfaBqFWWkdNbOWUbjrEcIJoj3hVi7azXxlGjKqF0oz74VGaOxNg/sB2wEFgbMn9SjTEAtrtIAW1mgB4QTCCYQTCCcQTuDTF6DljoIH0XxoEgaUh2uM0UdpTYODIQwZGQxhzKhgRMNRWp3nN5jc0vjpQiOs63r6cqyHkvXaFfSnF3S1OkNKqyUILR1q1+wTQfz1yFazd27vaxKeCOJfs/cEM/riY0Wy5MpNCiPMQDtZcvWHb9nyEk4gnEA4gXAC4QTCCYQTCCcQTiCcQM3JLJYz6USDnwa3XNi2y2vdHmtpyNng1iX9tnKuWdKP0AhHnzkVoTK4Nlt39iPqGjnn20d5cTHPcy6/PfNoaITaD8+uMts1iYLGDy7/zN4cQxIeAAAAAElFTkSuQmCC",
    cact_l3   = "iVBORw0KGgoAAAANSUhEUgAAAEsAAAAyCAYAAAAUYybjAAACR0lEQVR4nO1b266DIBBE4wP/56ufxz+6b554IoYgyHIfUichjZVCd9idXWidjuMQHBDRo6OUchKDIceOhTvBtm2P95VSx0iE5doxhTzLN4GGUirLw8yVrkl8CTtYntXKAAXuqXOvicmx0ue1S1PEr5M1IrqGYQ3U1MBlBOMl0+jaGggdhnQZz9GxFhoISxYZxqMIPyxZiCiuWXR5AHK9lJoolpJZhIzQQS8wUxLFbN7ULUUfyJoARWdi8ZYo5hEr6V74BB6RLCI6RvfWJmSRoYncAlMAovp2hxzCf2YXX/+3M6feGEKzlHUw18vz5hGJ2iKzdSlyF0RyTLiIMsM5VPiWDGs4sk6gVv7wYRhDsO2VP0cWMfVGHxLWJAyaLGKKudmvJmGQmuUTc+GAT/Rd/XPFfikVAgI8SeTsHHT54iWLuwqbp5+eAJHIFDtuzSod4yrzJ30U2HYs+uKM8RIFnGIQhbz/e7PjDkMtirGGqJeKO2fc1gjZ8SgdUtOulHLSrVfBWAIhOx4C70q7JbxCDuJhb3Bmw1rHIdJaiNGIa16UymshQotge6KLWPu92lkYersjI7SuRbkCu93haJ1JZIu6Dp4sW+ts0loWv9BhaAJhRzAMWQj4yIrAR1YEPrJ6kUWDnF2l2lGMLEr48RMRb3Y4ydIdYwyXV7WdcpxbCyXtcJJlMqv/+RIzkfCMxR7E8X1SP1fKjhvnU2F22/f90K+htq7r/6trHHMs3z272fft8X19a9txtuAjdJwVlJUffWtRvXPm+QNMj/DM02X7OgAAAABJRU5ErkJggg==",
    cloud     = "iVBORw0KGgoAAAANSUhEUgAAAC4AAAAOCAYAAABQFS4BAAAAkElEQVR4nNWUSw7AIAhEJelZuP955jI2XTShBrUF/HR2RoMPBqA0QQCyPDMzeWO6A/QgS1iI+4gEQnRB1cA9b4fphvgKAgf4kYJktR3G1gkDt4pF72sO1JIxg3v7E0CWUBpg6w+XvaO3AhprlKwVnb3KUDhEKysaPsTL92tDDzY50dp075YIgExv22I3+PRXnQICfHC2dHPTAAAAAElFTkSuQmCC",
    gameover  = "iVBORw0KGgoAAAANSUhEUgAAAL8AAAALCAYAAAAusVxlAAAA+0lEQVR4nO2ZYQ7DIAiFbeMRPSZ3tOkyM2KoOgtaLN+vLmse+IaM2i3G6BIhhN8HAgDY3A0ofU7NXCuP1xOr5sld/R4kf6eg3M8W/aTr/02oh5L++R1X0aQ4p570mmbRsi7sw5CklJH8+RR/jrRpWovzacVU68xPBwbUWckfX/qb4+BKH28A7k6lrQiMOZCdX2o+187VplrVlyA8Ro70k4q1cwcxDPWdX2K3S48jOGeJ/Fft8BjKN45Tnhl+1qaXPb/Z5mVjZXB9+5EnLyNOJ97QnaWBr4fan/tqte2pxVr3p5F+CdgCdUomlQdkY6RT6Ce1kdO1PfAa7q0cytjTA2rxfCsAAAAASUVORK5CYII=",
    restart   = "iVBORw0KGgoAAAANSUhEUgAAACQAAAAgCAYAAAB6kdqOAAAA1UlEQVR4nO2YQQ6EIAxFgbjoIXu8f0fYMakzRDczlFjAMfwVGi3PfkqJPufsilJKx8VAEZEv4+0Mw8wzeByAXKDCbBiRzF3c8THGqTBnAXhn6E4K7klAANztMgRjKBPLYAi1WU0KYC/fb+9oKzlYZgA/ntPGCJZ2cCULmlhqy0StlpR7LR9lsqjZcKe/DMTGbecSEHfogc9qHT20gEz3IXTo7s2WsWElaWKp1hAbQGljqC3jQefuVWU1rQz9X4aIyI/Y8GoSBmHZMzQbCh8YGfu7/Y55ATA2WS/0mUzQAAAAAElFTkSuQmCC",
}

-- 100px modular horizon tiles (strictly clipped to window bounds)
local HORIZON_TILES_B64 = {
    "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",
}

-- Night Mode Celestial Sprites
local NIGHT_SPRITES_B64 = {
    moon_crescent = "iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAkUlEQVR4nO2TvQ7AIAiE9eY2vv9jknZvpybGKKABuniTP4TPQ0hpqxJd95OiQGQEyxLoW5fzYGO1QiRsCPSCdYHejQHP5CKwdWddzn8dUtBQIwJSawNjS0oOjQTrhGqgx5AvObQuK+rNyKUlFNpAKyjaA+4vLaDoHXpCM3cpJV/p7KwJmnFVhEdMvZADR83xtF7qT0cMtv6uWgAAAABJRU5ErkJggg==",
    moon_half     = "iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAfUlEQVR4nO3WsQqAMAwE0Bgclfz/ZxbddbEQQgKhJBmCt3Worzd5AN2zrV4c1/3wM52H61u4CmoPkI9IBb0wRoMzFpoGWmgqqKHpoEwJOFjLng15y74NZ34wPNgWpO9/2bMhsTXQryGJrZMKkjKs0kAyVtxeBUE06N2l5XkBWCEn5IEFuMQAAAAASUVORK5CYII=",
    moon_full     = "iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAjklEQVR4nO2WOw6AIBBEYWvN3P+YRHttLAhhCb9hjXFa5b3MAlHnvh7f8nI4zkt7hn2rYvlRUavYzxLVioUhK60XhqzEEZZM46kjZUWY7XJcu4aB1C7l2+7hisgSS5RfyBspKr9nvcHDt91DkFoi4tqfUkxuiYSXbThLigxHHemoFMr6d/21uQYx+x535waCAjwuWd/V4wAAAABJRU5ErkJggg==",
    star1         = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAH0lEQVR4nGNgIAd8/PzlP1kaGYgxiQlZAhdNZzcRBQD93B6771mM4gAAAABJRU5ErkJggg==",
    star2         = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAHklEQVR4nGNgoBn4+PnLf6IU4FSIroBoheS7iSIAAHvXIpATpKu3AAAAAElFTkSuQmCC",
    star3         = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAHElEQVR4nGNgGFjw8fOX/+hiTNgUYFNI0CQ6AwAAVQ9fyBSLPwAAAABJRU5ErkJggg==",
}

local SPRITES = {}
for k, v in pairs(SPRITES_B64) do
    SPRITES[k] = b64decode(v)
end

local HORIZON_TILES = {}
for i, v in ipairs(HORIZON_TILES_B64) do
    HORIZON_TILES[i] = b64decode(v)
end

local NIGHT_SPRITES = {}
for k, v in pairs(NIGHT_SPRITES_B64) do
    NIGHT_SPRITES[k] = b64decode(v)
end

-- ── Window Geometry (Sizeable 1000x340 Canvas, Centered on Screen) ──
local WIN_W   = 1000
local WIN_H   = 340

-- Screen resolution detection to center the window
local screenW, screenH = 1920, 1080
pcall(function()
    local cam = workspace.CurrentCamera
    if cam and cam.ViewportSize and cam.ViewportSize.X > 100 then
        screenW = cam.ViewportSize.X
        screenH = cam.ViewportSize.Y
    else
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        if mouse and mouse.ViewSizeX and mouse.ViewSizeX > 100 then
            screenW = mouse.ViewSizeX
            screenH = mouse.ViewSizeY
        end
    end
end)

local winX = math.max(10, math.floor((screenW - WIN_W) / 2))
local winY = math.max(10, math.floor((screenH - WIN_H) / 2))

-- Ground and character relative positioning
local GND_R       = 275
local DINO_W      = 44
local DINO_H      = 47
local DINO_DUCK_W = 59
local DINO_DUCK_H = 30
local DINO_XR     = 70

-- Chromium Physics Constants (Exact matching Runner.config)
local GRAVITY                = 0.65
local INITIAL_JUMP_VEL       = -13.5
local SPEED_DROP_COEFFICIENT = 3.0
local INITIAL_SPEED          = 6.5
local MAX_SPEED              = 15.0

-- Day / Night Theme Palettes
local DAY_COLORS = {
    bg     = Color3.fromRGB(247, 247, 247),
    border = Color3.fromRGB(210, 210, 210),
    ink    = Color3.fromRGB(83, 83, 83),
    hi     = Color3.fromRGB(145, 145, 145),
    dim    = Color3.fromRGB(130, 130, 130),
}

local NIGHT_COLORS = {
    bg     = Color3.fromRGB(32, 33, 36),
    border = Color3.fromRGB(60, 64, 67),
    ink    = Color3.fromRGB(241, 243, 244),
    hi     = Color3.fromRGB(154, 160, 166),
    dim    = Color3.fromRGB(180, 185, 190),
}

local nightLerp = 0.0 -- 0.0 = full day, 1.0 = full night

local function lerpColor(c1, c2, t)
    return Color3.new(
        c1.R + (c2.R - c1.R) * t,
        c1.G + (c2.G - c1.G) * t,
        c1.B + (c2.B - c1.B) * t
    )
end

-- ── Drawing Factories (Explicit lifecycle, no rogue global visibility) ──
local function sq(x, y, w, h, col, filled, z, corner)
    local s = Drawing.new("Square")
    s.Position = Vector2.new(x, y)
    s.Size     = Vector2.new(w, h)
    s.Color    = col
    s.Filled   = filled
    s.ZIndex   = z or 1
    s.Visible  = false
    if corner then s.Corner = corner end
    return s
end

local function img(data, w, h, x, y, z)
    local i = Drawing.new("Image")
    i.Data     = data
    i.Size     = Vector2.new(w, h)
    i.Position = Vector2.new(x, y)
    i.ZIndex   = z or 3
    i.Visible  = false
    return i
end

local function txt(s, x, y, sz, col, font, z)
    local t = Drawing.new("Text")
    t.Text     = s
    t.Position = Vector2.new(x, y)
    t.Size     = sz or 14
    t.Color    = col or DAY_COLORS.ink
    t.Font     = font or Drawing.Fonts.Minecraft
    t.Outline  = false
    t.ZIndex   = z or 5
    t.Visible  = false
    return t
end

-- ── Window Frame Elements (Clean white canvas, grey X, no top grey bar) ──
local wBorder  = sq(winX - 1, winY - 1, WIN_W + 2, WIN_H + 2, DAY_COLORS.border, false, 9, 4)
local wGame    = sq(winX, winY, WIN_W, WIN_H, DAY_COLORS.bg, true, 1, 4)
local wTitleTx = txt("dino", winX + 16, winY + 10, 14, DAY_COLORS.dim, Drawing.Fonts.UI, 11)
local wCloseX  = txt("x", winX + WIN_W - 22, winY + 8, 15, DAY_COLORS.dim, Drawing.Fonts.UI, 12)

-- Modular 100px Horizon Tiles (12 tiles strictly clipped to window width)
local hTileObjs = {}
for i = 1, 12 do
    local tile = img(HORIZON_TILES[i], 100, 12, winX + (i - 1) * 100, winY + GND_R - 6, 2)
    hTileObjs[i] = tile
end

-- Clouds
local CLOUD_COORDS = { { 140, 45 }, { 380, 30 }, { 680, 55 }, { 880, 38 } }
local clouds = {}
for _, c in ipairs(CLOUD_COORDS) do
    local cImg = img(SPRITES.cloud, 46, 14, winX + c[1], winY + c[2], 2)
    clouds[#clouds + 1] = { d = cImg, rx = c[1], ry = c[2] }
end

-- Celestial Night Elements (Moon & Twinkling Stars)
local moonImg = img(NIGHT_SPRITES.moon_crescent, 28, 28, winX + 780, winY + 32, 3)
local moonRX = 780

local STAR_DEFS = {
    { rx = 160, ry = 42, tick = 0 },
    { rx = 340, ry = 68, tick = 15 },
    { rx = 520, ry = 30, tick = 30 },
    { rx = 710, ry = 58, tick = 45 },
    { rx = 900, ry = 36, tick = 10 },
}
local starObjs = {}
for i, s in ipairs(STAR_DEFS) do
    local sImg = img(NIGHT_SPRITES.star1, 9, 9, winX + s.rx, winY + s.ry, 3)
    starObjs[i] = { img = sImg, rx = s.rx, ry = s.ry, tick = s.tick }
end

-- Dedicated T-Rex Sprites (Running, Idle, Dead, and Ducking)
local dinoIdleImg  = img(SPRITES.trex_idle, DINO_W, DINO_H, winX + DINO_XR, winY + GND_R - DINO_H, 5)
local dinoRun1Img  = img(SPRITES.trex_run1, DINO_W, DINO_H, winX + DINO_XR, winY + GND_R - DINO_H, 5)
local dinoRun2Img  = img(SPRITES.trex_run2, DINO_W, DINO_H, winX + DINO_XR, winY + GND_R - DINO_H, 5)
local dinoDeadImg  = img(SPRITES.trex_dead, DINO_W, DINO_H, winX + DINO_XR, winY + GND_R - DINO_H, 5)
local dinoDuck1Img = img(SPRITES.duck1, DINO_DUCK_W, DINO_DUCK_H, winX + DINO_XR, winY + GND_R - DINO_DUCK_H, 5)
local dinoDuck2Img = img(SPRITES.duck2, DINO_DUCK_W, DINO_DUCK_H, winX + DINO_XR, winY + GND_R - DINO_DUCK_H, 5)

-- Score
local hiTx     = txt("HI 00000", winX + WIN_W - 190, winY + 12, 18, DAY_COLORS.hi, Drawing.Fonts.Minecraft, 6)
local scoreTx  = txt("00000", winX + WIN_W - 85, winY + 12, 18, DAY_COLORS.ink, Drawing.Fonts.Minecraft, 6)
local promptTx = txt("Press SPACE or Click to jump", winX + WIN_W / 2 - 120, winY + WIN_H / 2 - 8, 16, DAY_COLORS.ink, Drawing.Fonts.Minecraft, 6)

-- Game Over overlay
local goImg  = img(SPRITES.gameover, 191, 11, winX + WIN_W / 2 - 95, winY + WIN_H / 2 - 32, 7)
local rstImg = img(SPRITES.restart, 36, 32, winX + WIN_W / 2 - 18, winY + WIN_H / 2 - 6, 7)

-- ── Game State ────────────────────────────────────────────────
local shown       = false
local STATE       = "WAITING"
local distanceRan = 0
local score       = 0
local hiScore     = 0
local speed       = INITIAL_SPEED
local spawnTimer  = 0
local nextGap     = 220
local obstacles   = {}
local dinoYR      = GND_R - DINO_H
local dinoVY      = 0
local dinoGround  = true
local dinoFrame   = 1
local frameTick   = 0
local gndOffset   = 0
local isDucking   = false

local dragging    = false
local dragOX, dragOY = 0, 0
local lmbWas      = false
local spaceWas    = false
local f8Held      = false

-- ── Input Blocking ────────────────────────────────────────────
local CAS = nil
local Players = nil
local lp = nil
pcall(function()
    CAS = game:GetService("ContextActionService")
    Players = game:GetService("Players")
    lp = Players.LocalPlayer
end)

local function setInputBlock(block)
    pcall(function()
        setrobloxinput(not block)
    end)

    pcall(function()
        if CAS then
            if block then
                CAS:BindActionAtPriority("BlockDinoJump", function()
                    return Enum.ContextActionResult.Sink
                end, false, 999999, Enum.KeyCode.Space, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl)
            else
                CAS:UnbindAction("BlockDinoJump")
            end
        end
    end)

    pcall(function()
        if lp and lp.Character then
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if block then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                    hum.Jump = false
                else
                    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                end
            end
        end
    end)
end

-- ── Explicit Position Application & Bounds Enforcement ───────
local function applyPositions()
    pcall(function()
        wBorder.Position  = Vector2.new(winX - 1, winY - 1)
        wGame.Position    = Vector2.new(winX, winY)
        wTitleTx.Position = Vector2.new(winX + 16, winY + 10)
        wCloseX.Position  = Vector2.new(winX + WIN_W - 22, winY + 8)

        wBorder.Visible  = shown
        wGame.Visible    = shown
        wTitleTx.Visible = shown
        wCloseX.Visible  = shown
        scoreTx.Visible  = shown
        hiTx.Visible     = shown

        -- Strict Horizon Tile Clipping (Only tiles strictly within [0, WIN_W - 100] are visible)
        for i = 1, 12 do
            local rx = ((i - 1) * 100 - gndOffset) % 1200
            if shown and rx >= 0 and rx <= WIN_W - 100 then
                hTileObjs[i].Position = Vector2.new(winX + rx, winY + GND_R - 6)
                hTileObjs[i].Visible  = true
            else
                hTileObjs[i].Visible  = false
            end
        end

        -- Clouds
        for _, c in ipairs(clouds) do
            if shown and c.rx >= 0 and c.rx <= WIN_W - 46 then
                c.d.Position = Vector2.new(winX + c.rx, winY + c.ry)
                c.d.Visible  = true
            else
                c.d.Visible  = false
            end
        end

        -- Dino Images
        dinoIdleImg.Position  = Vector2.new(winX + DINO_XR, winY + dinoYR)
        dinoRun1Img.Position  = Vector2.new(winX + DINO_XR, winY + dinoYR)
        dinoRun2Img.Position  = Vector2.new(winX + DINO_XR, winY + dinoYR)
        dinoDeadImg.Position  = Vector2.new(winX + DINO_XR, winY + dinoYR)
        dinoDuck1Img.Position = Vector2.new(winX + DINO_XR, winY + dinoYR)
        dinoDuck2Img.Position = Vector2.new(winX + DINO_XR, winY + dinoYR)

        if shown then
            if STATE == "WAITING" then
                dinoIdleImg.Visible  = true
                dinoRun1Img.Visible  = false
                dinoRun2Img.Visible  = false
                dinoDeadImg.Visible  = false
                dinoDuck1Img.Visible = false
                dinoDuck2Img.Visible = false
                promptTx.Visible     = true
                goImg.Visible        = false
                rstImg.Visible       = false
            elseif STATE == "DEAD" then
                dinoIdleImg.Visible  = false
                dinoRun1Img.Visible  = false
                dinoRun2Img.Visible  = false
                dinoDeadImg.Visible  = true
                dinoDuck1Img.Visible = false
                dinoDuck2Img.Visible = false
                promptTx.Visible     = false
                goImg.Visible        = true
                rstImg.Visible       = true
            else
                promptTx.Visible     = false
                goImg.Visible        = false
                rstImg.Visible       = false
            end
        end

        hiTx.Position     = Vector2.new(winX + WIN_W - 190, winY + 12)
        scoreTx.Position  = Vector2.new(winX + WIN_W - 85, winY + 12)
        promptTx.Position = Vector2.new(winX + WIN_W / 2 - 120, winY + WIN_H / 2 - 8)

        goImg.Position  = Vector2.new(winX + WIN_W / 2 - 95, winY + WIN_H / 2 - 32)
        rstImg.Position = Vector2.new(winX + WIN_W / 2 - 18, winY + WIN_H / 2 - 6)

        -- Obstacles
        for _, o in ipairs(obstacles) do
            if o and o.img then
                if shown and o.rx >= 0 and o.rx <= WIN_W - o.w then
                    o.img.Position = Vector2.new(winX + o.rx, winY + o.ry)
                    o.img.Visible  = true
                else
                    o.img.Visible  = false
                end
            end
        end
    end)
end

-- ── Show / Hide System ────────────────────────────────────────
local function setVisible(v)
    shown = v
    if v then
        setInputBlock(true)
        applyPositions()
    else
        pcall(function()
            wBorder.Visible      = false
            wGame.Visible        = false
            wTitleTx.Visible     = false
            wCloseX.Visible      = false
            scoreTx.Visible      = false
            hiTx.Visible         = false
            promptTx.Visible     = false
            goImg.Visible        = false
            rstImg.Visible       = false
            dinoIdleImg.Visible  = false
            dinoRun1Img.Visible  = false
            dinoRun2Img.Visible  = false
            dinoDeadImg.Visible  = false
            dinoDuck1Img.Visible = false
            dinoDuck2Img.Visible = false
            moonImg.Visible      = false
            for _, st in ipairs(starObjs) do if st.img then st.img.Visible = false end end
            for _, h in ipairs(hTileObjs) do h.Visible = false end
            for _, c in ipairs(clouds) do c.d.Visible = false end
            for _, o in ipairs(obstacles) do if o and o.img then o.img.Visible = false end end
        end)
        setInputBlock(false)
    end
end

local function toggleWindow(nextState)
    if nextState == nil then
        nextState = not shown
    end
    setVisible(nextState)
    pcall(function()
        local UILib = rawget(_G, "UI") or (getgenv and rawget(getgenv(), "UI")) or UI
        if UILib and UILib.SetValue then
            UILib.SetValue("dino_toggle", nextState)
        end
    end)
end

-- ── Official Matcha Menu Binding (UI.AddTab) ─────────────────
pcall(function()
    local UILib = rawget(_G, "UI") or (getgenv and rawget(getgenv(), "UI")) or UI
    if UILib and UILib.AddTab then
        UILib.AddTab("dino", function(tab)
            local sec = tab:Section("dino", "Left")
            sec:Toggle("dino_toggle", "toggle dino", false, function(state)
                if state ~= shown then
                    setVisible(state)
                end
            end)
            local kb = sec:Keybind("dino_kb", 0x77, "toggle") -- F8
            kb:AddToHotkey("dino", "dino_toggle")
            sec:Tip("Starts the offline Chrome Dino runner (Jump: Space/Up, Crouch: Ctrl/Down, Toggle: F8)")
        end)
    end
end)

-- ── Mouse Helpers ─────────────────────────────────────────────
local mouse = nil
pcall(function()
    mouse = game:GetService("Players").LocalPlayer:GetMouse()
end)

local function mousePos()
    if mouse then
        return mouse.X, mouse.Y
    end
    return 0, 0
end

local function hitTest(mx, my, x, y, w, h)
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

-- ── Obstacle Pool (Cacti & Pterodactyl Birds) ─────────────────
local CACTUS_VARIANTS = {
    { type = "cactus", sprite = SPRITES.cact_s1, w = 17, h = 35 },
    { type = "cactus", sprite = SPRITES.cact_s2, w = 34, h = 35 },
    { type = "cactus", sprite = SPRITES.cact_s3, w = 51, h = 35 },
    { type = "cactus", sprite = SPRITES.cact_l1, w = 25, h = 50 },
    { type = "cactus", sprite = SPRITES.cact_l2, w = 50, h = 50 },
    { type = "cactus", sprite = SPRITES.cact_l3, w = 75, h = 50 },
}

local PTERO_ALTITUDES = {
    GND_R - 38,  -- Low (must jump)
    GND_R - 65,  -- Mid (must duck)
    GND_R - 100, -- High (run safely under)
}

local function spawnObstacle()
    local rx = WIN_W + 20
    local oType = "cactus"
    local entry = nil

    -- Spawn Pterodactyls after score >= 200 (approx 25% chance)
    if score >= 200 and math.random(1, 4) == 1 then
        oType = "ptero"
        local ry = PTERO_ALTITUDES[math.random(1, #PTERO_ALTITUDES)]
        local o = Drawing.new("Image")
        o.Data     = SPRITES.ptero1
        o.Size     = Vector2.new(46, 40)
        o.Position = Vector2.new(winX + rx, winY + ry)
        o.ZIndex   = 4
        o.Visible  = shown

        entry = {
            type  = "ptero",
            img   = o,
            rx    = rx,
            ry    = ry,
            w     = 46,
            h     = 40,
            frame = 1,
            tick  = 0,
        }
    else
        local variant = CACTUS_VARIANTS[math.random(1, #CACTUS_VARIANTS)]
        local ry = GND_R - variant.h
        local o = Drawing.new("Image")
        o.Data     = variant.sprite
        o.Size     = Vector2.new(variant.w, variant.h)
        o.Position = Vector2.new(winX + rx, winY + ry)
        o.ZIndex   = 4
        o.Visible  = shown

        entry = {
            type = "cactus",
            img  = o,
            rx   = rx,
            ry   = ry,
            w    = variant.w,
            h    = variant.h,
        }
    end

    obstacles[#obstacles + 1] = entry
    return entry
end

local function clearObstacles()
    for _, o in ipairs(obstacles) do
        if o and o.img then
            pcall(function()
                o.img.Visible = false
                o.img:Remove()
            end)
        end
    end
    obstacles = {}
end

-- ── Reset Game ────────────────────────────────────────────────
local function resetGame()
    clearObstacles()
    distanceRan = 0
    score       = 0
    speed       = INITIAL_SPEED
    spawnTimer  = 0
    nextGap     = 220
    dinoYR      = GND_R - DINO_H
    dinoVY      = 0
    dinoGround  = true
    dinoFrame   = 1
    nightLerp   = 0.0
    isDucking   = false

    gndOffset = 0
    scoreTx.Text = "00000"

    goImg.Visible    = false
    rstImg.Visible   = false
    promptTx.Visible = false

    STATE = "PLAYING"
    applyPositions()
end

-- Start hidden by default
setVisible(false)
applyPositions()

-- ── Main Game Loop (Protected & Resilient) ────────────────────
while true do
    task.wait(1 / 60)

    pcall(function()
        local mx, my = mousePos()
        local lmb = ismouse1pressed()
        local spc = iskeypressed(0x20) or iskeypressed(0x26) -- Space or Up
        local duck = iskeypressed(0x11) or iskeypressed(0x28) or iskeypressed(0x53) -- Ctrl or Down or S
        local enter = iskeypressed(0x0D) -- Enter

        -- Dynamic Hotkey (default F8 = 0x77 / 119 or user-bound key in Matcha)
        local boundKey = 0x77
        pcall(function()
            local UILib = rawget(_G, "UI") or (getgenv and rawget(getgenv(), "UI")) or UI
            if UILib and UILib.GetValue then
                local k = UILib.GetValue("dino_kb")
                if type(k) == "number" and k > 0 then
                    boundKey = k
                end
            end
        end)

        local hotkeyPressed = iskeypressed(boundKey) or iskeypressed(0x77)
        local lmbFresh      = lmb and not lmbWas
        local spaceFresh    = spc and not spaceWas

        -- ── True Hardware Level Hotkey Toggle Debounce ─────────
        if hotkeyPressed then
            if not f8Held then
                f8Held = true
                toggleWindow(not shown)
            end
        else
            f8Held = false
        end

        if not shown then
            lmbWas   = lmb
            spaceWas = spc
            return
        end

        -- ── Suppress Roblox Character Jumping Every Tick ─────────
        pcall(function()
            if lp and lp.Character then
                local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Jump = false
                    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                end
            end
        end)

        -- ── Close Button Click (Grey X in top right) ─────────────
        if lmbFresh and hitTest(mx, my, winX + WIN_W - 28, winY + 4, 26, 26) then
            toggleWindow(false)
            lmbWas   = lmb
            spaceWas = spc
            return
        end

        -- ── Window Dragging (Holding click anywhere in top 50px) ──
        local inTopBar = hitTest(mx, my, winX, winY, WIN_W - 35, 50)
        if lmb and inTopBar and not dragging then
            dragging = true
            dragOX   = mx - winX
            dragOY   = my - winY
        end

        if dragging then
            if lmb then
                winX = mx - dragOX
                winY = my - dragOY
                applyPositions()
            else
                dragging = false
            end
        end

        -- ── Game Jump / Start Trigger ────────────────────────────
        local inGameCanvas = hitTest(mx, my, winX, winY + 50, WIN_W, WIN_H - 50)
        local jumpTrigger = spaceFresh or (lmbFresh and inGameCanvas and not dragging and not inTopBar)

        -- ── Day / Night Inversion (Every 1000 Score Points) ──────
        local scoreCycle = score % 2000
        local isNight = (scoreCycle >= 1000 and scoreCycle <= 1600)

        if isNight then
            nightLerp = math.min(1.0, nightLerp + 0.02)
        else
            nightLerp = math.max(0.0, nightLerp - 0.02)
        end

        local curBg     = lerpColor(DAY_COLORS.bg, NIGHT_COLORS.bg, nightLerp)
        local curBorder = lerpColor(DAY_COLORS.border, NIGHT_COLORS.border, nightLerp)
        local curInk    = lerpColor(DAY_COLORS.ink, NIGHT_COLORS.ink, nightLerp)
        local curHi     = lerpColor(DAY_COLORS.hi, NIGHT_COLORS.hi, nightLerp)
        local curDim    = lerpColor(DAY_COLORS.dim, NIGHT_COLORS.dim, nightLerp)

        wGame.Color     = curBg
        wBorder.Color   = curBorder
        wTitleTx.Color  = curDim
        wCloseX.Color   = curDim
        scoreTx.Color   = curInk
        hiTx.Color      = curHi
        promptTx.Color  = curInk

        -- ── State Machine ────────────────────────────────────────
        if STATE == "WAITING" then
            dinoIdleImg.Visible  = shown
            dinoRun1Img.Visible  = false
            dinoRun2Img.Visible  = false
            dinoDeadImg.Visible  = false
            dinoDuck1Img.Visible = false
            dinoDuck2Img.Visible = false
            dinoIdleImg.Position = Vector2.new(winX + DINO_XR, winY + GND_R - DINO_H)
            moonImg.Visible = false
            for _, st in ipairs(starObjs) do if st.img then st.img.Visible = false end end

            if jumpTrigger then
                resetGame()
            end

        elseif STATE == "PLAYING" then
            -- Progressive speed scaling as score increases
            speed = math.min(INITIAL_SPEED + (score * 0.0035), MAX_SPEED)

            -- Initial Jump Velocity
            if jumpTrigger and dinoGround then
                dinoVY     = INITIAL_JUMP_VEL
                dinoGround = false
                isDucking  = false
            end

            -- Fast drop when down/ctrl is pressed in air
            local curGravity = GRAVITY
            if duck and not dinoGround then
                curGravity = GRAVITY * SPEED_DROP_COEFFICIENT
            end

            -- Physics & Velocity
            dinoVY = dinoVY + curGravity
            dinoYR = dinoYR + dinoVY

            -- Short hop: if jump key released early while rising, cut ascent
            if not spc and not lmb and dinoVY < -4.0 and not dinoGround then
                dinoVY = dinoVY * 0.75
            end

            -- Landing on Ground
            if dinoYR >= GND_R - DINO_H then
                dinoYR     = GND_R - DINO_H
                dinoVY     = 0
                dinoGround = true
            end

            -- Determine if Ducking on Ground
            isDucking = dinoGround and duck

            -- Animation & Active Sprite Switcher
            local activeImg = dinoIdleImg
            if dinoGround then
                frameTick = frameTick + 1
                local ticksPerFrame = math.max(3, math.floor(30 / speed))
                if frameTick >= ticksPerFrame then
                    frameTick = 0
                    dinoFrame = (dinoFrame == 1) and 2 or 1
                end

                if isDucking then
                    activeImg = (dinoFrame == 1) and dinoDuck1Img or dinoDuck2Img
                    dinoYR = GND_R - DINO_DUCK_H
                else
                    activeImg = (dinoFrame == 1) and dinoRun1Img or dinoRun2Img
                    dinoYR = GND_R - DINO_H
                end
            else
                -- Jumping pose
                activeImg = dinoIdleImg
            end

            dinoIdleImg.Visible  = (activeImg == dinoIdleImg) and shown
            dinoRun1Img.Visible  = (activeImg == dinoRun1Img) and shown
            dinoRun2Img.Visible  = (activeImg == dinoRun2Img) and shown
            dinoDuck1Img.Visible = (activeImg == dinoDuck1Img) and shown
            dinoDuck2Img.Visible = (activeImg == dinoDuck2Img) and shown
            dinoDeadImg.Visible  = false

            activeImg.Position = Vector2.new(winX + DINO_XR, winY + dinoYR)

            -- Ground Scroll (Tiled 100px slices strictly clipped inside window)
            gndOffset = (gndOffset + speed) % 1200
            for i = 1, 12 do
                local rx = ((i - 1) * 100 - gndOffset) % 1200
                if shown and rx >= 0 and rx <= WIN_W - 100 then
                    hTileObjs[i].Position = Vector2.new(winX + rx, winY + GND_R - 6)
                    hTileObjs[i].Visible  = true
                else
                    hTileObjs[i].Visible  = false
                end
            end

            -- Cloud Parallax (Strict instant clipping at window borders)
            for _, c in ipairs(clouds) do
                c.rx = c.rx - speed * 0.2
                if c.rx <= 0 then
                    c.rx = WIN_W - 46
                end
                if shown and c.rx >= 0 and c.rx <= WIN_W - 46 then
                    c.d.Position = Vector2.new(winX + c.rx, winY + c.ry)
                    c.d.Visible  = true
                else
                    c.d.Visible  = false
                end
            end

            -- Moon & Star Parallax in Night Mode
            local showNightSky = shown and (nightLerp > 0.15)
            moonRX = moonRX - speed * 0.05
            if moonRX < -30 then
                moonRX = WIN_W + 30
            end

            if showNightSky and moonRX >= 0 and moonRX <= WIN_W - 28 then
                moonImg.Position = Vector2.new(winX + moonRX, winY + 32)
                moonImg.Visible  = true
            else
                moonImg.Visible  = false
            end

            for _, st in ipairs(starObjs) do
                st.rx = st.rx - speed * 0.1
                if st.rx <= 0 then st.rx = WIN_W - 10 end
                st.tick = (st.tick + 1) % 60

                local twinklePhase = math.floor(st.tick / 20)
                if twinklePhase == 0 then
                    st.img.Data = NIGHT_SPRITES.star1
                elseif twinklePhase == 1 then
                    st.img.Data = NIGHT_SPRITES.star2
                else
                    st.img.Data = NIGHT_SPRITES.star3
                end

                if showNightSky and st.rx >= 0 and st.rx <= WIN_W - 10 then
                    st.img.Position = Vector2.new(winX + st.rx, winY + st.ry)
                    st.img.Visible  = true
                else
                    st.img.Visible  = false
                end
            end

            -- Spawn Obstacles using real Chromium Gap Formula
            spawnTimer = spawnTimer + speed
            if spawnTimer >= nextGap then
                spawnTimer = 0
                local spawned = spawnObstacle()
                local minGap = math.floor(DINO_W * speed + spawned.w * 0.6)
                nextGap = math.random(minGap, math.floor(minGap * 2.2))
            end

            -- Move Obstacles, Flap Bird Wings & Check Collision
            local isDead = false
            local toRemove = {}

            for idx, o in ipairs(obstacles) do
                o.rx = o.rx - speed

                -- Pterodactyl Wing Flapping
                if o.type == "ptero" then
                    o.tick = o.tick + 1
                    if o.tick >= 10 then
                        o.tick = 0
                        o.frame = (o.frame == 1) and 2 or 1
                        o.img.Data = (o.frame == 1) and SPRITES.ptero1 or SPRITES.ptero2
                    end
                end

                -- Instant border clipping: hidden if outside [0, WIN_W - o.w], removed the moment rx < 0
                if o.rx < 0 then
                    toRemove[#toRemove + 1] = idx
                elseif o.rx > WIN_W - o.w then
                    o.img.Visible = false
                else
                    o.img.Visible  = shown
                    o.img.Position = Vector2.new(winX + o.rx, winY + o.ry)
                end

                -- Hitbox definition based on Dino State (Standing vs Crouching)
                local function boxesOverlap(a, b)
                    return a.x + a.w > b.x and a.x < b.x + b.w and a.y + a.h > b.y and a.y < b.y + b.h
                end

                local obsBox = { x = o.rx + 4, y = o.ry + 4, w = o.w - 8, h = o.h - 8 }

                if isDucking then
                    -- Crouched Dino Hitbox (low height allowing ducking under mid birds)
                    local duckBox = { x = DINO_XR + 6, y = dinoYR + 4, w = DINO_DUCK_W - 12, h = DINO_DUCK_H - 6 }
                    if boxesOverlap(duckBox, obsBox) then
                        isDead = true
                    end
                else
                    -- Full standing Dino (Dual head/body hitboxes)
                    local dinoBody = { x = DINO_XR + 8,  y = dinoYR + 14, w = DINO_W - 16, h = DINO_H - 16 }
                    local dinoHead = { x = DINO_XR + 20, y = dinoYR + 2,  w = 22,          h = 18 }

                    if boxesOverlap(dinoBody, obsBox) or boxesOverlap(dinoHead, obsBox) then
                        isDead = true
                    end
                end
            end

            for i = #toRemove, 1, -1 do
                local obs = obstacles[toRemove[i]]
                if obs and obs.img then
                    pcall(function()
                        obs.img.Visible = false
                        obs.img:Remove()
                    end)
                end
                table.remove(obstacles, toRemove[i])
            end

            -- Distance & Score Counter
            distanceRan = distanceRan + speed
            score = math.floor(distanceRan * 0.025)
            scoreTx.Text = string.format("%05d", score)

            if score > hiScore then
                hiScore = score
                hiTx.Text = "HI " .. string.format("%05d", hiScore)
            end

            if isDead then
                dinoIdleImg.Visible  = false
                dinoRun1Img.Visible  = false
                dinoRun2Img.Visible  = false
                dinoDuck1Img.Visible = false
                dinoDuck2Img.Visible = false
                dinoDeadImg.Visible  = shown
                dinoDeadImg.Position = Vector2.new(winX + DINO_XR, winY + dinoYR)

                goImg.Visible  = true
                rstImg.Visible = true
                STATE = "DEAD"
            end

        elseif STATE == "DEAD" then
            if jumpTrigger or enter then
                goImg.Visible  = false
                rstImg.Visible = false
                task.wait(0.12)
                resetGame()
            end
        end

        lmbWas   = lmb
        spaceWas = spc
    end)
end
