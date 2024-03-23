require File.join(File.dirname(__FILE__), 'spec_helper')

def exception_from(&block)
  exception = nil

  begin
    block.call
  rescue => e
    exception = e
  end

  raise 'Expected block to raise an exception!' if exception.nil?

  exception.message
end

describe DataMapper::Resource do
  before :each do
    @person = Person.new
    @friend = Person.new
  end

  describe '#save' do
    it 'raises an exception with a descriptive error message when a resource cannot be saved' do
      exception_from do
        @person.save
      end.should =~ /name.*blank/i
    end

    it 'includes the class name in to which any errors are related' do
      exception_from do
        @person.save
      end.should =~ /Person/
    end

    it 'includes information about failures from other records in any exception raised' do
      @person.name = 'Joe Schmoe'
      @person.memberships << Membership.new
      exception_from do
        @person.save
      end.should =~ /Membership.*type.*blank/i
    end

    it 'includes each relevant error message in the event there are multiple' do
      exception_from do
        Address.create
      end.should =~ /address.*blank.*city.*blank.*state.*blank.*zipcode.*blank/im
    end

    it 'does not erroneously raise an error when all records are properly saved (even if #save? returned false)' do
      @person.name = 'Joe Schmoe'
      @person.memberships << Membership.new
      @person.memberships.first.type = 'gym'
      @person.save
      @person.saved?.should be_true
      @person.memberships.first.saved?.should be_true
    end

    it 'does not block the creation of many-to-many associations' do
      @person.name = 'Sally Social'
      @person.friends << Person.create(name: 'Freddy')
      @person.friends << Person.create(name: 'Fannie')
      @person.save
      @person.reload
      @person.friends.map(&:name).should =~ %w(Freddy Fannie)
    end
  end

  describe '#save?' do
    it 'returns true or false to indicate whether a record saved successfully or not' do
      @person.name = 'Joe Schmoe'
      @person.save?.should be_true
      @person.name = nil
      @person.save?.should be_false
    end
  end

  describe '#create' do
    it 'raises an exception on failure, same as #save' do
      exception_from do
        Person.create
      end.should =~ /name.*blank/i
    end
  end

  describe '#create?' do
    it 'returns an instance or nil depending on whether the record was saved successfully or not' do
      Person.create?.should be_nil
      Person.create?(name: 'Joe Schmoe').should be_a(Person)
    end
  end

  describe 'update' do
    it 'raises an exception on failure, same as #save' do
      @person.name = 'Joe Schmoe'
      @person.save
      exception_from do
        @person.update(name: nil)
      end.should =~ /name.*blank/i
      @person.reload
      lambda {
        @person.update(name: 'Johnny Q. Public')
      }.should_not raise_error
    end
  end

  describe 'update?' do
    it 'returns true or false, same as #save?' do
      @person.name = 'Joe Schmoe'
      @person.save
      @person.update?(name: 'Johnny Q. Public').should be_true
      @person.update?(name: nil).should be_false
    end
  end

  describe '#destroy' do
    it 'raises an exception on failure, though not necessarily with a descriptive message' do
      @person.name = 'Joe Schmoe'
      @person.save
      @person.memberships.create(type: 'gym')
      lambda {
        @person.destroy
      }.should raise_error
    end
  end

  describe '#destroy?' do
    it 'returns true or false, same as #save?' do
      @person.name = 'Joe Schmoe'
      @person.save
      @person.memberships.create(type: 'pool')
      @person.destroy?.should be_false
      @person.memberships.destroy
      @person.reload
      @person.destroy?.should be_true
    end
  end
end
