require ('spec_helper.rb')
include ElectricEye

describe "check_dir" do
  context "when config directory does not exists" do
    before do
      @dir = "#{ENV['HOME']}/.electric_eye"
    end
    
    it "should make directory" do
      Dir.exist?(@dir).should == false
      ElectricEye.check_dir
      Dir.exist?(@dir).should == true
      Dir.rmdir(@dir)
    end

    it "should return the directory back" do
      ElectricEye.check_dir.should == @dir      
    end
  end
end
