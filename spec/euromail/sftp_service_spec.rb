require 'spec_helper'

describe Euromail::SFTPService do
  let(:service) do
    Euromail::SFTPService.new('somedomain.com', "stefan", "super_secret")
  end

  context "when creating" do
    it "has a host, username and password" do
      service.host.should eql('somedomain.com')
      service.username.should eql('stefan')
      service.password.should eql('super_secret')
    end
  end

end
