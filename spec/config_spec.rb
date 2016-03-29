require ('spec_helper.rb')
include ElectricEye

describe "initialize" do
  include FakeFS::SpecHelpers

  it "sets config" do
    configEye = ConfigEye.new

    # Check defaults
    expect(configEye.config.duration).to equal(600)
    expect(configEye.config.path).to include("~/recordings")
    expect(configEye.config.cameras.length).to equal(0)
  end
end

describe "check_dir" do
  include FakeFS::SpecHelpers
  
  context "when config directory does not exists" do
    it "makes a directory" do
      ConfigEye.check_dir
      expect(File.directory?(CONFIG_DIR)).to equal(true)
    end
  end
  
  context "when config directory exists" do
    it "doesn't make a directory" do
      FileUtils.mkdir_p(CONFIG_DIR) # Create the directory
      ConfigEye.check_dir
      expect(File.directory?(CONFIG_DIR)).to equal(true)
    end
  end
end

describe "save" do
  include FakeFS::SpecHelpers

  context "config is set" do
    it "writes the config file" do
      @configEye = ConfigEye.new
      @configEye.save
      expect(File.file?(CONFIG_FILE)).to equal(true)
    end
  end
end

describe "check config" do
  include FakeFS::SpecHelpers

  it "checks the directory" do
    ConfigEye.load
    expect(File.directory?(CONFIG_DIR)).to equal(true)
  end
  
  context "when exists" do
    before do
      # Create the file beforehand
      @configEye = ConfigEye.new
      @configEye.save
    end
    
    it "returns a construct object" do
      expect(File.directory?(CONFIG_DIR)).to equal(true)
      @config = ConfigEye.load      
      expect(@config.class).to equal(Construct)      
    end
  end
  
  context "doesn't exist" do
    before do
      @configEye = ConfigEye.load      
      expect(File.file?(CONFIG_FILE)).to equal(false)
    end

    it "returns a construct object" do
      expect(@configEye.class).to equal(Construct)      
    end

    it "includes a cameras array" do
      expect(@configEye.cameras.class).to equal(Array)      
    end
  end
end

describe "add camera" do
  include FakeFS::SpecHelpers

  before do
    @configEye = ConfigEye.new
  end

  context "when both name & url provided" do
    it "adds camera to array" do
      @configEye.add_camera("Reception", "http://user:pass@my.camera.org/live2.sdp")
      expect(@configEye.config.cameras.length).to equal(1)
    end

    it "calls save" do
      expect(@configEye).to receive(:save).once
      @configEye.add_camera("Reception", "http://user:pass@my.camera.org/live2.sdp")
    end
  end

  context "when only name provided" do
    it "returns an error" do
    end

    it "doesn't call save" do 
      expect(@configEye).to receive(:save).never
      @configEye.add_camera("Reception", nil)
    end
  end
end

describe "remove camera" do
  include FakeFS::SpecHelpers

  before do
    @configEye = ConfigEye.new
    @configEye.add_camera("Reception", "http://user:pass@my.camera.org/live2.sdp")
  end

  context "when camera exists" do
    it "removes camera from array" do
      expect(@configEye.config.cameras.length).to equal(1)
      @configEye.remove_camera("Reception")
      expect(@configEye.config.cameras.length).to equal(0)
    end

    it "calls save" do
      expect(@configEye).to receive(:save).once
      @configEye.remove_camera("Reception")
    end
  end

  context "when specified camera doesn't exist" do
    it "keeps the camera array the same size" do
      expect(@configEye.config.cameras.length).to equal(1)
      @configEye.remove_camera("Kitchen")
      expect(@configEye.config.cameras.length).to equal(1)
    end

    it "calls save" do
      expect(ConfigEye).to receive(:save).never
      @configEye.remove_camera("Kitchen")
    end
  end
end

describe "set_wrap" do
  include FakeFS::SpecHelpers

  before do
    @configEye = ConfigEye.new
  end

  context "when no wrap has been set" do
    it "returns the default of 168 times" do
      expect(@configEye.config.wrap).to equal(168)
    end
  end

  context "when calling with -w 24" do
    it "returns 24" do
      @configEye.set_wrap(24)
      expect(@configEye.config.wrap).to equal(24)
    end

    it "calls save" do
      expect(@configEye).to receive(:save).once
      @configEye.set_wrap(24)
    end
  end
end

describe "set_duration" do
  include FakeFS::SpecHelpers

  before do
    @configEye = ConfigEye.new
  end

  context "when no duration has been set" do
    it "returns the default of 600 seconds" do
      expect(@configEye.config.duration).to equal(600)
    end
  end

  context "when calling with -d 10" do
    it "returns 10" do
      @configEye.set_duration(10)
      expect(@configEye.config.duration).to equal(10)
    end

    it "calls save" do
      expect(@configEye).to receive(:save).once
      @configEye.set_duration(10)
    end
  end
end

describe "set_path" do
  include FakeFS::SpecHelpers

  before do
    @configEye = ConfigEye.new
  end

  context "when no path has been set" do
    it "returns the default of ~/recordings" do
      expect(@configEye.config.path == "~/recordings").to equal(true)
    end
  end

  context "when calling with -p '/data/recordings'" do
    it "returns '/data/recordings'" do
      @configEye.set_path('/data/recordings')
      expect(@configEye.config.path == '/data/recordings').to equal(true)
    end

    it "calls save" do
      expect(@configEye).to receive(:save).once
      @configEye.set_path('/data/recordings')
    end
  end
end

describe "set_threshold" do
  include FakeFS::SpecHelpers

  before do
    @configEye = ConfigEye.new
  end

  context "when no threshold has been set" do
    it "returns the default of 2 objects" do
      expect(@configEye.config.threshold).to equal(2)
    end
  end

  context "when calling with -d 3" do
    it "returns 3" do
      @configEye.set_threshold(3)
      expect(@configEye.config.threshold).to equal(3)
    end

    it "calls save" do
      expect(@configEye).to receive(:save).once
      @configEye.set_threshold(3)
    end
  end
end


