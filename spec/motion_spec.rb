require ('spec_helper.rb')

describe "motion" do
  before do
    @motion = ElectricEye::Motion.new
  end

  describe "#read_log" do
    context "with file passed" do
      before do
        @results = @motion.read_log('spec/fixtures/movement.log')
      end
      
      it "returns data" do
        expect(@results.nil?).to equal(false)
      end
      
      it "returns motion detect lines" do
        expect(@results[0]).to match(/motiondetect filter debug: Counted 0 moving shapes./)
      end
    end

    context "with a file which doesn't exist" do
      before do
        @results = @motion.read_log('spec/does/not/exist')
      end
      
      it "returns a blank array" do
        expect(@results.length).to equal(0)
      end
    end
  end

  describe "#get_movement" do
    context "with single digit" do
      it "returns 1" do
        expect(@motion.movement("[0x1572e58] motiondetect filter debug: Counted 1 moving shapes.")).to equal(1)
      end
    end

    context "with double digit" do
      it "returns 10" do
        expect(@motion.movement("[0x1572e58] motiondetect filter debug: Counted 10 moving shapes.")).to equal(10)
      end
    end
  end

  describe "#detect" do
    context "when there is movement" do
      before do
        @results = @motion.read_log('spec/fixtures/movement.log')
      end

      context "with a threshold of 2" do
        it "returns true" do
          expect(@motion.detect(@results,2)).to equal(true)
        end
      end

      context "with no threshold" do
        it "returns true" do
          expect(@motion.detect(@results)).to equal(true)
        end
      end
    end

    context "when there is no movement" do
      before do
        @results = @motion.read_log('spec/fixtures/no_movement.log')
      end

      it "returns false" do
        expect(@motion.detect(@results,2)).to equal(false)
      end
    end
  end
end
