require ('spec_helper.rb')

describe "check_dir" do
  context "when config directory does not exists" do
    it "should make and return the directory" do
      dir = "#{ENV['HOME']}/.electric_eye"
      Dir.exist?(dir).should == false
      ElectricEye.check_dir
      Dir.exist?(dir).should == true
      Dir.rmdir(dir)
    end
  end
end
