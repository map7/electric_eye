require ('spec_helper.rb')

describe "record" do
  include FakeFS::SpecHelpers

  before do
    @configEye = ConfigEye.new
    @configEye.add_camera("Reception", "http://user:pass@my.camera.org/live2.sdp")
    @record = Record.new(@configEye)
  end

  describe "store_pids" do
    before do
      @file = "/tmp/electric_eye.pid"
      ConfigEye.stub(:load).and_return(Construct.new({path: "~/recordings", cameras: [{name: "Reception"}]}))
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
    before do
      Timecop.freeze(Time.local(2015,06,30,10,05,0))
    end

    after do
      Timecop.return
    end
    
    it "returns a full path with todays date" do
      path = @record.path(@configEye.config.cameras.first)
      expect(path).to include("~/recordings/Reception/20150630-1005-Reception.mjpeg")
    end
  end
end
