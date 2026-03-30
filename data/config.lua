return {
    -- Auto-detect or force: 'auto', 'prp', 'esx', 'qb', 'qbox', 'standalone'
    Framework = 'auto',

    -- Auto-detect or 'auto', 'prp_target', 'ox_target', 'standalone'
    Target = 'auto',

    -- Auto-detect or 'msk_interactions', 'standalone'
    FloatingNotification = 'msk_interactions',

    --[[
        Auto-detect or force progress bar system:
        'auto'            - will try to detect progress bar system automatically
        'msk_progressbar' - MSK Progress Bar
        'ox_lib'          - ox_lib Progress Bar [recommended]
        'esx'             - ESX Progress Bar (esx_progressbar)
        'qb'              - QB Progress Bar (progressbar)
        'qs-interface'    - Quasar Interface Progress Bar
        'none'            - no progress bar (callbacks only)
    ]]
    ProgressBar = 'auto',

    --[[
        Auto-detect or force fuel system:
        'auto'              - will try to detect fuel system automatically
        'ox_fuel'           - ox_fuel (recommended)
        'LegacyFuel'        - LegacyFuel
        'lc_fuel'           - lc_fuel
        'cdn-fuel'          - cdn-fuel
        'rcore_fuel'        - rcore_fuel
        'x-fuel'            - CodeM Fuel
        'myFuel'            - myFuel
        'qs-fuelstations'   - Quasar Fuel Stations
        'okokGasStation'    - okok Gas Station
        'Renewed-Fuel'      - Renewed Fuel
        'msk_fuel'          - MSK Fuel (recommended)
        'none'              - no fuel system
    ]]
    Fuel = 'msk_fuel',
}