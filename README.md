dataloaderb: Create and Run Apex Data Loader Processes on Windows
=================================================================

dataloaderb is a library designed to help create and run Apex Data Loader processes without messing with tedious XML configuration.

More information coming soon!

Example
-------

This is just a loose spec of what the code might could should look like; things may change!

    # run several processes via a block
    ProcessRunner.new("C:/salesforce/dataloader/bin") do |runner|
      runner.run "processes/firstUpsert.yml"
      runner.run "processes/secondUpsert.yml"
      runner.run "processes/thirdUpsert.yml"
    end

    # or run without a block
    runner = ProcessRunner.new("C:/salesforce/dataloader/bin")
    ['firstUpsert.yml', 'secondUpsert.yml', 'thirdUpsert.yml'].each do |process|
      runner.run "#processes/{process}"
    end
    
    # redirecting_process_runner.rb
    