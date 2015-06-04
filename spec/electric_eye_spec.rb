require ('spec_helper.rb')
include ElectricEye

describe "store_pids" do
  before do
    @file = "/tmp/electric_eye.pid"
    ConfigEye.stub(:load).and_return(Construct.new({cameras: [{name: "Reception"}]}))
  end

  it "creates a file #{@file}" do
    store_pids
    expect(File.exist?(@file)).to equal(true)
  end

  it "should store the pids in the file" do
    pids = [100, 101, 102]
    store_pids(pids)
    output = File.open(@file, "r")
    pids = output.gets
    expect(pids == "100 101 102").to equal(true)
  end
end

describe "record_path" do
  before do
    Timecop.freeze(Time.local(2015,06,30,10,05,0))
    @configEye = ConfigEye.new
    puts @configEye.config.path
  end

  after do
    Timecop.return
  end
  
  it "returns a full path with todays date" do
    dir = record_path(@configEye.config.path)
    expect(dir).to include("~/recordings/20150630-1005")
  end
end
