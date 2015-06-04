require ('spec_helper.rb')

describe "record" do
  before do
    @record = Record.new
  end


  describe "store_pids" do
    include FakeFS::SpecHelpers

    before do
      @file = "/tmp/electric_eye.pid"
      FileUtils.mkdir("/tmp")
      ConfigEye.stub(:load).and_return(Construct.new({cameras: [{name: "Reception"}]}))
    end

    it "creates a file #{@file}" do
      @record.store_pids
      expect(File.exist?(@file)).to equal(true)
    end

    it "should store the pids in the file" do
      pids = [100, 101, 102]
      @record.store_pids(pids)
      expect(File.read(@file) == "100 101 102").to equal(true)
    end
  end

  describe "record_path" do
    include FakeFS::SpecHelpers

    before do
      Timecop.freeze(Time.local(2015,06,30,10,05,0))
      @configEye = ConfigEye.new
      puts @configEye.config.path
    end

    after do
      Timecop.return
    end
    
    it "returns a full path with todays date" do
      pending
      dir = @record.path(@configEye.config.path)
      expect(dir).to include("~/recordings/20150630-1005")
    end
  end
end
