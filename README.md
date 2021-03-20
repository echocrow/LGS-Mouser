# LGS Mouser

This personal Lua-based script automates various actions based on mouse button presses and simple swipe gestures. It was originally written for use with [Logitech Gaming Software](https://support.logi.com/hc/en-us/articles/360025298053) (short: LGS), and later adopted for its ~~successor~~ replacement, [Logitech G HUB](https://www.logitechg.com/en-us/innovation/g-hub.html).

Unfortunately Logitech broke Lua scripting support for its G HUB app during a Q4 2020 update, no longer including various standard Lua libraries this script depends upon. Although most of those missing standard libraries were re-added in a later patch, as of March 2021 some core features and standard library functions are still missing, including Lua's variable arguments and related `unpack` function. Despite some polyfilling attempts, as an unfortunate consequence this script is broken in those versions of G HUB. However, it remains functional in LGS and in G HUB prior to version `2020.12`.

In an attempt to preserve these custom button and gesture actions, a standalone and more configurable Go-based alternative, [Mouser](https://github.com/birdkid/Mouser), was created.

