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

  describe "#dir" do
    before do
      Timecop.freeze(Time.local(2015,06,30,10,05,0))
    end

    after do
      Timecop.return
    end
    
    it "returns a full dir" do
      dir = @record.dir(@configEye.config.cameras.first)
      expect(dir).to eq("~/recordings/Reception")
    end
  end

  describe "record_path" do
    before do
      Timecop.freeze(Time.local(2015,06,30,10,05,0))
    end

    after do
      Timecop.return
    end
    
    it "returns a full path" do
      path = @record.path(@configEye.config.cameras.first)
      expect(path).to eq("~/recordings/Reception/Reception")
    end
  end

  describe "get_pids" do
    it "returns pids" do
      File.open("/tmp/electric_eye.pid", "w") do |file|
        file.write("1 2 3")
      end

      expect(@record.get_pids == "1 2 3").to equal(true)
    end
  end

  describe "stop_recordings" do
    before do
      File.open("/tmp/electric_eye.pid", "w") do |file|
        file.write("10000 10001 10002")
      end
    end
    
    it "calls kill" do
      open4 = double(Open4)
      open4.stub(:exitstatus).and_return(0)
      
      Open4.should_receive(:popen4).with('kill -INT 10000 10001 10002').and_return(open4)

      @record.stop_recordings("10000 10001 10002")
    end

    it "removes the old file" do
      expect(File.exists?("/tmp/electric_eye.pid")).to equal(true)
      @record.stop_recordings("10000 10001 10002")
      expect(File.exists?("/tmp/electric_eye.pid")).to equal(false)
    end
  end

  describe "#read_listfile" do
    before do 
      FakeFS.activate!
    end

    after do 
      FakeFS.deactivate!
    end

    context "with a full file" do 
      before do 
        File.open("output.list", "w") do |file|
          file.puts "file1.mjpeg"
          file.puts "file2.mjpeg"
        end
      end

      it "returns the last filename" do
        @record.read_listfile("output.list").should eq("file2.mjpeg")
      end    
    end

    context "with a empty file" do 
      before do 
        File.open("output.list", "w") do |file|
        end
      end

      it "returns the last filename" do
        @record.read_listfile("output.list").should eq(nil)
      end    
    end
  end

  describe "#remove" do
    before do
      @path = "/tmp/electric_eye"
      File.new("#{@path}.log", "w")
      File.new("#{@path}.mjpeg", "w")
    end

    it "removes recording" do
      expect(File.exist?("#{@path}.mjpeg")).to equal(true)
      @record.remove(@path)
      expect(File.exist?("#{@path}.mjpeg")).to equal(false)
    end

    it "removes log" do
      expect(File.exist?("#{@path}.log")).to equal(true)
      @record.remove(@path)
      expect(File.exist?("#{@path}.log")).to equal(false)
    end
  end
end
