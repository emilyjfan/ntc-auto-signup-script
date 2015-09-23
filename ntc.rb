require 'capybara'
require 'capybara/dsl'

# YOUR NIKE.COM ACCOUNT INFO
FIRST_NAME = 'Firstname'
LAST_NAME = 'Lastname'
EMAIL = 'example@example.com'
PASSWORD = 'password'
BIRTH_DAY = '01'
BIRTH_MONTH = '01'
BIRTH_YEAR = '1986'
POSTAL_CODE = 'A1B2C3'
COUNTRY = 'Canada' # must be Capitalized

@session = Capybara::Session.new(:selenium)

@events_url = "https://www.nike.com/events-registration/series?id=1518"

def complete_sign_in_form
  @session.fill_in('Email', :with => EMAIL)
  @session.fill_in('Password', :with => PASSWORD)
  @session.click_on('Login')
end

def complete_ntc_nrc_event_form
  # for NTC classes, or NRC 'Ready Set Go Run', 'H.I.T & Run' & 'Long run'
  complete_common_event_form
  check_waiver_box
  @session.click_on('RESERVE A SPOT')
  sleep(5)
  @session.visit(@events_url)
end

def complete_nrc_speed_run_event_form
  # for NRC 'Speed Run'
  complete_common_event_form
  enter_pace
  check_waiver_box
  @session.click_on('RESERVE A SPOT')
  sleep(5)
  @session.visit(@events_url)
end

def complete_nrc_home_local_run_event_form
  # for NRC 'Home Run' or 'Local Run'
  complete_common_event_form
  enter_distance_and_pace
  check_waiver_box
  @session.click_on('RESERVE A SPOT')
  sleep(5)
  @session.visit(@events_url)
end

def complete_common_event_form
  enter_name_email
  enter_birth_date
  enter_location
end

def enter_name_email
  @session.fill_in('First Name', :with => FIRST_NAME)
  @session.fill_in('Last Name', :with => LAST_NAME)
  @session.fill_in('Email', :with => EMAIL)
end

def enter_birth_date
    @session.all('.select-element')[0].click
    @session.within '.has-focus' do
      @session.find('li', :text => BIRTH_MONTH).click
    end

    @session.all('.select-element')[1].click
    @session.within '.has-focus' do
      @session.find('li', :text => BIRTH_DAY).click
    end

    @session.all('.select-element')[2].click
    @session.within '.has-focus' do
      @session.find('li', :text => BIRTH_YEAR).click
    end
end

def enter_location
  @session.fill_in('Zip Code', :with => POSTAL_CODE)
  @session.all('.select-element')[3].click
  @session.within '.has-focus' do
    @session.find('li', :text => COUNTRY).click
  end
end

def enter_distance_and_pace
  @session.within '.field15-container' do
    @session.find('.select-element').click

    @session.within '.has-focus' do
      @session.find('li', :text => '5km').click
    end
  end


  @session.within '.field16-container' do
    @session.find('.select-element').click

    @session.within '.has-focus' do
      @session.all('li')[3].click
    end
  end
end

def enter_pace
  @session.within '.field15-container' do
    @session.find('.select-element').click

    @session.within '.has-focus' do
      @session.all('li')[3].click
    end
  end

end

def check_waiver_box
  @session.within '.field27-container' do
      @session.find('.input-checkbox-container').click
      @session.all('span')[0].click
  end
end

@session.visit(@events_url)

# SIGN UP FOR EVENTS
# enter events' <li> numbers below:
event_li_nums = [4, 6]

event_li_nums.each_with_index do |event_li_num, index|
  @session.find(:xpath, "//div[2]/section/article/div[1]/ul/li[#{event_li_num}]/dl/dd/ul[2]/li[2]/button[1]").click

  if index == 0
    complete_sign_in_form

    # complete_ntc_nrc_event_form
    # OR
    # complete_nrc_speed_run_event_form
    # OR
    complete_nrc_home_local_run_event_form
  else
    complete_ntc_nrc_event_form
    # OR
    # complete_nrc_speed_run_event_form
    # OR
    # complete_nrc_home_local_run_event_form
  end

  p "Signed up for event number #{event_li_num}!"
end
