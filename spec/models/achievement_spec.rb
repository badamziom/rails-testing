require 'rails_helper'

RSpec.describe Achievement, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).scoped_to(:user_id).with_message("you can't have two achievements with the same title") }
    it { should validate_presence_of(:user) }
    it { should belong_to(:user) }
    it { should have_many(:encouragements) }
  end

  it 'converts markdown to html' do
    achievement = Achievement.new(description: 'Awesome **thing** I *actually* did')
    expect(achievement.description_html).to include('<strong>thing</strong>')
    expect(achievement.description_html).to include('<em>actually</em>')
  end

  it 'has silly title' do
    achievement = Achievement.new(title: 'New Achievement', user: FactoryGirl.create(:user, email: 'test@test.com'))
    expect(achievement.silly_title).to eq('New Achievement by test@test.com')
  end

  it 'only fetches achievements which starts from provider letter' do
    user = FactoryGirl.create(:user)
    achievement1 = FactoryGirl.create(:public_achievement, title: 'Read a book', user: user)
    achievement2 = FactoryGirl.create(:public_achievement, title: 'Passed an exam', user: user)
    expect(Achievement.by_letter("R")).to eq([achievement1])
  end

  it 'sorts achievements by user emails' do
    albert = FactoryGirl.create(:user, email: 'albert@gmail.com')
    rob = FactoryGirl.create(:user, email: 'rob@gmail.com')
    achievement1 = FactoryGirl.create(:public_achievement, title: 'Read a book', user: rob)
    achievement2 = FactoryGirl.create(:public_achievement, title: 'Rocket it', user: albert)

    expect(Achievement.by_letter('R')).to eq([achievement2, achievement1])
  end

end
