require 'spec_helper'

module Ovto
  describe Component do
    before do
      @comp = Component.new(nil)
    end

    def o(*args, &block)
      js_node = @comp.send(:o, *args, &block)
      return JSON.parse(`JSON.stringify(js_node)`)
    end

    context '#o' do
      it 'empty tag' do
        node = o("div")
        expect(node).to eq({
          nodeName: "div",
          attributes: {},
          children: [],
        })
      end

      describe 'tag_name' do
        it 'can have .class and #id' do
          node = o("div.main#app")
          expect(node).to eq({
            nodeName: "div",
            attributes: {class: 'main', id: 'app'},
            children: [],
          })
        end

        it 'can have #id and .class' do
          node = o("div#app.main")
          expect(node).to eq({
            nodeName: "div",
            attributes: {class: 'main', id: 'app'},
            children: [],
          })
        end

        it 'can have #id but may be superceded by attributes' do
          node = o("div#main", {id: 'main2'})
          expect(node).to eq({
            nodeName: "div",
            attributes: {id: 'main2'},
            children: [],
          })
        end
      end

      describe 'attributes' do
        it 'is ignored if the value is falsy' do
          node = o("div", id: "foo", class: nil)
          expect(node).to eq({
            nodeName: "div",
            attributes: {id: "foo"},
            children: [],
          })
        end
      end

      describe 'content' do
        it 'content as argument' do
          node = o("div", {}, "hi")
          expect(node).to eq({
            nodeName: "div",
            attributes: {},
            children: ["hi"],
          })
        end

        it 'content as argument (attributes ommited)' do
          node = o("div", "hi")
          expect(node).to eq({
            nodeName: "div",
            attributes: {},
            children: ["hi"],
          })
        end

        it 'content in block' do
          node = o("div"){ "hi" }
          expect(node).to eq({
            nodeName: "div",
            attributes: {},
            children: ["hi"],
          })
        end

        it 'contents' do
          node = o("div", {}, ["hello", "world"])
          expect(node).to eq({
            nodeName: "div",
            attributes: {},
            children: ["hello", "world"],
          })
        end

        def foo; :foo; end
        it 'nested' do
          node = o "div" do
            o "pre", foo
          end
          expect(node).to eq({
            nodeName: "div",
            attributes: {},
            children: [{
              nodeName: "pre",
              attributes: {},
              children: ["foo"]
            }]
          })
        end
      end

      describe 'text' do
        it 'on the toplevel' do
          node = o('text', 'foo')
          expect(node).to eq('foo')
        end

        it 'in a block' do
          node = o('span'){ o('text', 'foo') }
          expect(node).to eq({
            nodeName: "span",
            attributes: {},
            children: ['foo']
          })
        end
      end

      it 'key'
      it 'onxx'
    end
  end
end