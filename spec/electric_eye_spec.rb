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
