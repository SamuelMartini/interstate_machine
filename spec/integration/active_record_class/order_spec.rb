require 'spec_helper'

RSpec.describe ActiveRecord::Order do
  let(:order) { described_class.new }
  context 'when transition is possible' do
    context 'From Cart to Address' do
      before do
        expect(order.state).to eq 'cart'
        allow_any_instance_of(ActiveRecord::Order).to receive(:line_items) { [1] }
        order.next
      end
      it 'runs to next state' do
        expect(order.state).to eq 'address'
      end
    end

    context 'From Address to Delivery' do
      before do
        order.state = 'address'
        order.address = 'street'
        order.next
      end

      it 'runs to next state' do
        expect(order.state).to eq 'delivery'
      end
    end

    context 'From Payment to Confirm' do
      before do
        order.state = 'payment'
        allow(Gateway).to receive(:authorize) { true }
        order.next
      end

      it 'runs to next state' do
        expect(order.state).to eq 'confirm'
      end
    end

    context 'from confirm to complete' do
      before do
        order.state = 'confirm'
        order.complete
      end

      it 'runs to next state' do
        expect(order.state).to eq 'completed'
      end
    end
  end

  context 'when transition is NOT possible' do
    context 'From Cart to Address' do
      before do
        expect(order.state).to eq 'cart'
        allow_any_instance_of(ActiveRecord::Order).to receive(:line_items) { [] }
        order.next
      end

      it 'does not run to next state' do
        expect(order.state).to eq 'cart'
        expect(order.errors.messages[:base]).to eq ['no line items for this order']
      end
    end

    context 'From Address to Delivery' do
      context 'when missing address' do
        before do
          order.state = 'address'
          order.address = ''
          order.next
        end

        it 'does not runs to next state' do
          expect(order.state).to eq 'address'
          expect(order.errors.messages[:base]).to eq ['no address for this order']
        end
      end

      context 'when shipment region is not allowed' do
        before do
          order.state = 'address'
          order.address = 'Death Star'
          order.next
        end

        it 'does not runs to next state' do
          expect(order.state).to eq 'address'
          expect(order.errors.messages[:base]).to eq ['we do not  ship to Death Star']
        end
      end
    end

    context 'From Payment to Confirm' do
      before do
        order.state = 'payment'
        allow(Gateway).to receive(:authorize) { 'failed' }
        order.next
      end

      it 'runs to next state' do
        expect(order.state).to eq 'payment'
        expect(order.errors.messages[:base]).to eq ['payment not authorized']
      end
    end

    context 'from confirm to complete' do
      before do
        order.state = 'confirm'
      end

      it 'runs to next state' do
        expect { order.next }.to raise_error RuntimeError
      end
    end
  end
end
