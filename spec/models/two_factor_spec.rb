require 'spec_helper'

describe TwoFactor do

  describe 'uniq validate' do
    let(:member) { create :member }
    let(:two_factor) { member.two_factors.by_type(:app) }

    it "reject duplicate two_factor" do
      duplicate = TwoFactor.new two_factor.attributes
      expect(duplicate).not_to be_valid
    end
  end

  describe 'self.fetch_by_type' do
    it "return nil for wrong type" do
      expect(TwoFactor.by_type(:foobar)).to be_nil
    end

    it "create new one by type" do
      expect(TwoFactor.by_type(:app)).not_to be_nil
    end

    it "find exist one by tyep" do
      two_factor = TwoFactor::App.create
      expect(TwoFactor.by_type(:app)).to eq(two_factor)
    end
  end

  describe '.activated' do
    before { create :member, :two_factor_activated }

    it "should has activated" do
      expect(TwoFactor.activated?).to be_true
    end
  end

  describe '#active!' do
    subject { create :two_factor }
    before { subject.active! }

    its(:activated?) { should be_true }
  end

  describe '#deactive!' do
    subject { create :two_factor, activated: true }
    before { subject.deactive! }

    its(:activated?) { should_not be_true }
  end

end

