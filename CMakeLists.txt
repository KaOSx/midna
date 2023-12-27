cmake_minimum_required(VERSION 3.16.0 FATAL_ERROR)

project(MidnaTheme)

# Macro to print feature summary
include(FeatureSummary)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Find ECM
find_package(ECM 1.5.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

# Set version
set(THEME_VERSION_MAJOR 7)
set(THEME_VERSION_MINOR 0)
set(THEME_VERSION_PATCH 0)
set(THEME_VERSION_STRING "${THEME_VERSION_MAJOR}.${THEME_VERSION_MINOR}.${THEME_VERSION_PATCH}")

# Installation directories
include(KDEInstallDirs)

# Add custom uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)
add_custom_target(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")

# Set up packaging
set(CPACK_PACKAGE_NAME "midna-theme")
set(CPACK_PACKAGE_VERSION "${THEME_VERSION_STRING}")
set(CPACK_GENERATOR "TGZ")
set(CPACK_SET_DESTDIR FALSE)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
set(CPACK_SOURCE_IGNORE_FILES "/build/;/.git;/*.user;/.tx/;~$;${CPACK_SOURCE_IGNORE_FILES}")
include(CPack)
add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

# Minimum version requirements
set(QT_MIN_VERSION "6.4.0")
set(PROJECT_VERSION "5.90.0")

# Find KF6
find_package(Plasma ${PROJECT_VERSION} REQUIRED)

# Subdirectories
add_subdirectory(aurorae)
add_subdirectory(colors)
add_subdirectory(icons)
add_subdirectory(midna-kvantum)
add_subdirectory(look-and-feel)
add_subdirectory(plasma)
add_subdirectory(qtcurve)
add_subdirectory(sddm)
add_subdirectory(wallpapers)

# Display featute summary
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
