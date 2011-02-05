require 'spec_helper'

describe LicenseFinder::LicenseFile do
  subject { LicenseFinder::LicenseFile.new('gem', 'gem/license/path') }

  context "ignoring text" do
    before do
      stub(IO).read { "file text" }
    end

    describe "#to_hash" do
      it "includes file path" do
        subject.to_hash['file_name'].should == 'license/path'
      end
      
      it "does not include file text by default" do
        subject.to_hash['text'].should be_nil
      end

      it "includes file text if requested" do
        subject.include_license_text = true
        subject.to_hash['text'].should == 'file text'
      end
    end
  end

  context "with MIT like license" do
    before do
      stub(IO).read { File.read('spec/fixtures/MIT-LICENSE')}
    end

    its(:body_type) { should == 'mit' }
  end

  context "with another license" do
    before do
      stub(IO).read { "a non-standard license" }
    end

    its(:body_type) { should == 'other' }
  end
end
