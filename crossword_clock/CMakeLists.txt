cmake_minimum_required(VERSION 3.16)

project(crossword-clock)

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})
include(KDEInstallDirs)

find_package(Plasma REQUIRED)
find_package(KF6Kirigami REQUIRED)

plasma_install_package(package com.github.ismailof.crossword-clock)
