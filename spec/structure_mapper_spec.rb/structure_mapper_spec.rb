require 'spec_helper'

describe StructureMapper::Array do

  describe :to_structure do
    context "when object is mapped to hash" do
      context "when object has one String property" do
        subject do
          type=Class.new do
            include StructureMapper::Hash
            attribute a: String
          end

          r=type.new
          r.a="test"
          r
        end

        it "should map to hash with that property set" do
          subject.to_structure.should == {'a' => 'test'}
        end
      end
      context "when object has one Mapped object property" do
        subject do
          type=Class.new do
            include StructureMapper::Hash
            attribute a: self
          end
          inner=type.new
          r=type.new
          r.a=inner
          r
        end

        it "should map to hash with that property set" do
          subject.to_structure.should == {'a' => {'a' => nil}}
        end
      end
    end

    context "when object is mapped to array" do
      context "when object has one String property" do
        subject do
          type=Class.new do
            include StructureMapper::Array
            attribute a: String
          end

          r=type.new
          r.a="test"
          r
        end

        it "should map to hash with that property set" do
          subject.to_structure.should == ['test']
        end
      end
    end

    context "when object has one Mapped object property" do
      subject do
        type=Class.new do
          include StructureMapper::Array
          attribute a: self
        end
        inner=type.new
        r=type.new
        r.a=inner
        r
      end

      it "should map to hash with that property set" do
        subject.to_structure.should == [[nil]]
      end
    end

  end



  describe :from_structure do
    context "when array has one String attribute" do
      let(:data) { ['value']}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: String
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 'value'
      end
    end

    context "when array has one Fixnum attribute" do
      let(:data) { [1]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Fixnum
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 1
      end

    end

    context "when array has one Boolean attribute" do
      let(:data) { [true]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == true
      end

    end

    context "when array has one untyped array attribute" do
      let(:data) { [[1,2,3]]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == [1,2,3]
      end

    end

    context "when array has one untyped hash attribute" do
      let(:data) { [{'a'=>'b'}]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == {'a'=>'b'}
      end

    end


    context "when array has one mapped hash attribute" do
      let(:data) { [{'b'=>'c'}]}
      subject do
        inner = Class.new do
          include StructureMapper::Hash
          attribute b: String
        end
        Class.new do
          include StructureMapper::Array
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == "c"
      end

    end


    context "when array has one mapped array attribute" do
      let(:data) { [['c']]}
      subject do
        inner = Class.new do
          include StructureMapper::Array
          attribute b: String
        end
        Class.new do
          include StructureMapper::Array
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == "c"
      end

    end

  end
end

describe StructureMapper::Hash do

  describe :from_structure do

    context "when hash has one attribute that is hash of String keys and  mapped object values" do
      let(:data) { {'a' => {'x' => [{'b' => 'c'}]} }}
      let(:inner_class) {Class.new {include StructureMapper::Hash; attribute b: String;}}
      subject do
        inner=inner_class
        Class.new do
          include StructureMapper::Hash
          attribute a: {String => [inner]}
        end
      end
      it "should map the attribute to the array of objects" do
        expected=inner_class.new
        expected.b='c'
        subject.from_structure(data).a.should == {'x' => [expected]}

      end
    end

    context "when hash has one String attribute" do
      let(:data) { {'a' => 'b'}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: String
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 'b'
      end
    end

    context "when hash has one Fixnum attribute" do
      let(:data) { {'a' => 1}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: Fixnum
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 1
      end
    end

    context "when hash has one Array of strings attribute" do
      let(:data) { {'a' => ['one','two']}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: [String]
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == ['one','two']
      end
    end

    context "when hash has untyped hash attribute" do
      let(:data) { {'a' => {'one' => 'two'}}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: {}
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == {'one' => 'two'}
      end
    end

    context "when hash has untyped array attribute" do
      let(:data) { {'a' => ['one','two']}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: []
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == ['one','two']
      end
    end

    context "when hash has typed hash attribute" do
      let(:data) { {'a' => {'one' => 'two'}}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: {String => String}
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == {'one' => 'two'}
      end
    end

    context "when hash has typed array attribute" do
      let(:data) { {'a' => ['one','two']}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: [String]
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == ['one','two']
      end
    end

    context "when hash has boolean attribute" do
      let(:data) { {'a' => true} }
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == true
      end
    end


    context "when hash has mapped hash object attribute" do
      let(:data) { {'a' => {'b' => 'c'}}}
      subject do
        inner = Class.new do
          include StructureMapper::Hash
          attribute b: String
        end

        Class.new do
          include StructureMapper::Hash
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == 'c'
      end
    end

    context "when hash has one mapped array object attribute" do
      let(:data) { {'a' => ['c']}}
      subject do
        inner = Class.new do
          include StructureMapper::Array
          attribute b: String
        end
        Class.new do
          include StructureMapper::Hash
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == "c"
      end

    end

  end

end
