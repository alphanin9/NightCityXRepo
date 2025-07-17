package("red4ext-sdk")
  add_deps("cmake")

  set_homepage("https://github.com/wopss/RED4ext.SDK")
  set_description("A library to create mods for REDengine 4 (Cyberpunk 2077), independently of RED4ext.")
  set_license("MIT")

  -- Set this to your own repo when making some PR.
  add_urls("https://github.com/wopss/RED4ext.SDK.git")

  add_configs("headeronly", {description = "Header-only mode", default = false, type = "boolean"})

  on_load("windows", function(package)
    -- Ensure proper value for "shared" and "kind" for header-only mode.
    if package:config("headeronly") then
      package:config_set("shared", false)
      package:set("kind", "library", { headeronly = true })

      -- TODO: This should be fixed in RED4ext.SDK CMake file! Works for other build types without this...
      package:add("defines", "RED4EXT_HEADER_ONLY", {public = true})
    end
  end)

  on_install("windows", function (package)
    local configs = {}
    table.insert(configs, "-DRED4EXT_HEADER_ONLY=" .. (package:config("headeronly") and "ON" or "OFF"))
    table.insert(configs, "-DRED4EXT_BUILD_EXAMPLES=OFF")
    table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
    table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

    import("package.tools.cmake").install(package, configs)
  end)

  on_test("windows", function (package)
    assert(package:has_cxxincludes("RED4ext/CName.hpp", {configs = {languages = "cxx20"}}))
    assert(package:has_cxxincludes("D3D12Downlevel.h", {configs = {languages = "cxx20"}}))
    assert(package:has_cxxincludes("D3D12MemAlloc.h", {configs = {languages = "cxx20"}}))
  end)