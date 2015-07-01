require ('spec_helper.rb')

describe "motion" do
  describe "read_log" do
    before do
      @motion = ElectricEye::Motion.new
    end
    context "with file passed" do
      before do
        @result = @motion.read_log('spec/fixtures/movement.log')
      end
      
      it "returns data" do
        expect(@result.nil?).to equal(false)
      end
      
      it "returns motion detect lines" do
        expect(@result[0]).to match(/motiondetect filter debug: Counted 0 moving shapes./)
      end
    end

    context "with a file which doesn't exist" do
      before do
        @result = @motion.read_log('spec/does/not/exist')
      end
      
      it "returns a blank array" do
        expect(@result.length).to equal(0)
      end
    end
  end

end
