require ('spec_helper.rb')
include ElectricEye

describe "check_dir" do
  context "when config directory does not exists" do
    it "makes a directory" do
      Dir.stub(:exist?).and_return(false)
      Dir.stub(:mkdir).and_return(true)
      expect(Dir).to receive(:mkdir).once.and_return(true)
      ConfigEye.check_dir
    end
  end
  
  context "when config directory exists" do
    it "doesn't make a directory" do
      Dir.stub(:exist?).and_return(true)
      expect(Dir).to receive(:mkdir).exactly(0)
      ConfigEye.check_dir
    end
  end
end

describe "save" do
  context "config is set" do
    it "writes the config file" do
      @config = double()
      expect(File).to receive(:open).once
      ConfigEye.save(@config)
    end
  end

  context "config isn't set" do
    it "writes the config file" do
      expect(File).to receive(:open).once
      ConfigEye.save(nil)
    end
  end
end

describe "check config" do
  it "checks the directory" do
    expect(ConfigEye).to receive(:check_dir).once
    ConfigEye.check_config
  end
  
  context "exists" do
    it "returns a construct object" do
      File.stub(:exist?).and_return(true)
      config = ConfigEye.check_config      
      expect(config.class).to equal(Construct)      
    end
  end
  
  context "doesn't exist" do
    before do
      File.stub(:exist?).and_return(false)
      @config = ConfigEye.check_config      
    end

    it "returns a construct object" do
      expect(@config.class).to equal(Construct)      
    end

    it "includes a cameras array" do
      expect(@config.cameras.class).to equal(Array)      
    end
  end
end
