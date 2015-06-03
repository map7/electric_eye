require ('spec_helper.rb')
include ElectricEye

describe "initialize" do
  before do
    ConfigEye.stub(:load).and_return(Construct.new({cameras: [{name: "Reception"}]}))
  end

  it "sets config" do
    configEye = ConfigEye.new
    expect(configEye.config.cameras.length).to equal(1)
  end
end

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
    ConfigEye.load
  end
  
  context "exists" do
    it "returns a construct object" do
      File.stub(:exist?).and_return(true)
      config = ConfigEye.load      
      expect(config.class).to equal(Construct)      
    end
  end
  
  context "doesn't exist" do
    before do
      File.stub(:exist?).and_return(false)
      @config = ConfigEye.load      
    end

    it "returns a construct object" do
      expect(@config.class).to equal(Construct)      
    end

    it "includes a cameras array" do
      expect(@config.cameras.class).to equal(Array)      
    end
  end
end

describe "add camera" do
  before do
    ConfigEye.stub(:load).and_return(Construct.new({cameras: []}))
  end
  
  it "adds camera to array" do
    @config = ConfigEye.add_camera("Reception", "http://user:pass@my.camera.org/live2.sdp")
    expect(@config.cameras.length).to equal(1)
  end

  it "calls save" do
    expect(ConfigEye).to receive(:save).once
    @config = ConfigEye.add_camera("Reception", "http://user:pass@my.camera.org/live2.sdp")
  end
end

describe "remove camera" do
  before do
    ConfigEye.stub(:load).and_return(Construct.new({cameras: [{name: "Reception"}]}))
  end

  context "when camera exists" do
    it "removes camera from array" do
      @config = ConfigEye.load
      expect(@config.cameras.length).to equal(1)
      @config = ConfigEye.remove_camera("Reception")
      expect(@config.cameras.length).to equal(0)
    end

    it "calls save" do
      expect(ConfigEye).to receive(:save).once
      ConfigEye.remove_camera("Reception")
    end
  end

  context "when camera doesn't exist" do
    it "keeps the camera array the same size" do
      @config = ConfigEye.load
      expect(@config.cameras.length).to equal(1)
      @config = ConfigEye.remove_camera("Kitchen")
      expect(@config.cameras.length).to equal(1)
    end

    it "calls save" do
      expect(ConfigEye).to receive(:save).never
      ConfigEye.remove_camera("Kitchen")
    end
  end

  
end
