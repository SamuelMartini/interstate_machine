require 'spec_helper'

RSpec.describe PlainRuby::Order do
  let!(:order) { described_class.new }

  context 'From Cart to Payment' do
    before { expect(order.state).to eq :cart }

    context 'when transition is possible' do
      before { allow_any_instance_of(PlainRuby::Order).to receive(:line_items) { [1] } }

      it 'runs to next state' do
        expect { order.next }.to change { order.state }.from(:cart).to(:payment)
      end
    end

    context 'when transition is not possible' do
      before { allow_any_instance_of(PlainRuby::Order).to receive(:line_items) { [] } }

      it 'does not run to next state' do
        expect { order.next }.to_not change { order.state }.from(:cart)
      end
    end
  end

  context 'From Payment to Complete' do
    before { order.state = :payment }

    context 'when transition is possible' do
      before do
        allow(Gateway).to receive(:authorize).and_return(success?: true)
      end

      it 'runs to next state' do
        expect { order.complete }.to change { order.state }.from(:payment).to(:complete)
      end
    end

    context 'when transition is not possible' do
      before do
        allow(Gateway).to receive(:authorize).and_return(success?: false)
      end

      it 'does not run to next state' do
        expect { order.complete }.to_not change { order.state }.from(:payment)
      end
    end
  end
end
