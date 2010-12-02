dataloaderb: Create and Run Apex Data Loader Processes on Windows
=================================================================

dataloaderb is a library designed to help create and run Apex Data Loader processes without messing with tedious XML configuration.

Specify your processes via clean Yaml files and point the `ProcessRunner` at them. The runner will create the XML on the fly and pass the appropriate options to the Apex Data Loader.

Extend the default `ProcessRunner` to do additional logging, reporting, or cleanup!

More info coming soon.

Example
-------

This is just a loose spec of what the code might could should look like; things may change!

`runner.rb`:

    # run several processes via a block
    ProcessRunner.new("C:/salesforce/dataloader/bin") do |runner|
      runner.run "processes/firstUpsert.yml"
      runner.run "processes/secondUpsert.yml"
      runner.run "processes/thirdUpsert.yml"
    end

    # or run without a block
    runner = ProcessRunner.new("C:/salesforce/dataloader/bin")
    ['firstUpsert.yml', 'secondUpsert.yml', 'thirdUpsert.yml'].each do |process|
      runner.run "processes/#{process}"
    end

`processes/firstUpsert.yml`:

    id: 'firstUpsert'
    description: 'Upsert of some data somewhere'
    properties:
      # endpoint config
      sfdc.endpoint:             'https://www.salesforce.com'
      sfdc.username:             'xxxxxxxxxx@xxxxxxxxxx.xxx'
      sfdc.password:             'xxxxxxxxxxxxxxxxxxxxxxxxx'
      process.encryptionKeyFile: 'C:/salesforce/dataloader/enc_pass.key'

      # operation config
      sfdc.timeoutSecs:     '600'
      sfdc.loadBatchSize:   '100'
      sfdc.externalIdField: 'Custom_Field__c'
      sfdc.entity:          'Account'
      process.operation:    'upsert'
      process.mappingFile:  '//shared/salesforce/upserts/first.Mapping.sdl'
      dataAccess.name:      '//shared/salesforce/upserts/first.csv'
      dataAccess.type:      'csvRead'

      # logging config
      sfdc.debugMessages:            'true'
      process.statusOutputDirectory: '//shared/salesforce/upserts/first/lastrun'

      # misc config
      process.enableLastRunOutput:   'false'
      process.initialLastRunDate:    '2010-01-01T00:00:00.000-0800'
    
