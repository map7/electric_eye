require ('spec_helper.rb')
include ElectricEye

describe "check_dir" do
  context "when config directory does not exists" do
    it "makes a directory" do
      Dir.stub(:exist?).and_return(false)
      Dir.stub(:mkdir).and_return(true)
      expect(Dir).to receive(:mkdir).once.and_return(true)
      check_dir
    end
  end
  
  context "when config directory exists" do
    it "doesn't make a directory" do
      Dir.stub(:exist?).and_return(true)
      expect(Dir).to receive(:mkdir).exactly(0)
      check_dir
    end
  end
end

describe "save" do
  context "config is set" do
    it "writes the config file" do
      @config = double()
      expect(File).to receive(:open).once
      save(@config)
    end
  end

  context "config isn't set" do
    it "writes the config file" do
      expect(File).to receive(:open).once
      save(nil)
    end
  end
end

