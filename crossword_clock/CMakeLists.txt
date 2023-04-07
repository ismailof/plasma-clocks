cmake_minimum_required(VERSION 3.16)

project(crossword-clock)

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})
include(KDEInstallDirs)

find_package(KF5Plasma REQUIRED)

plasma_install_package(package com.github.ismailof.crossword-clock)

