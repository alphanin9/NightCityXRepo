package("red-lib")
    set_homepage("https://github.com/psiberx/cp2077-red-lib")
    set_description("Header-only library to help create RED4ext plugins.")
    set_license("MIT")

    add_urls("https://github.com/psiberx/cp2077-red-lib.git")
    add_versions("2025.02.01", "93237f705531327d4c6f0414ebef2cb75875b45f")

    add_deps("cmake")

    on_install(function (package)
        local configs = {}

        package:add("defines", "NOMINMAX")

        import("package.tools.cmake").install(package, configs)
    end)
