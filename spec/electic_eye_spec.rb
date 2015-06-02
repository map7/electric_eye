require ('spec_helper.rb')
include ElectricEye

describe "check_dir" do
  context "when config directory does not exists" do
    before do
      Dir.stub(:exist?).and_return(false)
      Dir.stub(:mkdir).and_return(true)
    end

    it "makes a directory" do
      expect(Dir).to receive(:mkdir).once.and_return(true)
      check_dir
    end
  end
  
  context "when config directory exists" do
    before do
      Dir.stub(:exist?).and_return(true)
    end

    it "doesn't make a directory" do
      expect(Dir).to receive(:mkdir).exactly(0)
      check_dir
    end
  end
end

describe "save" do
  context "config is set" do
    before do
      @config = Construct.new
    end

    it "writes the config file" do
      expect(File).to receive(:open).once
      save(@config)
    end
  end
end
