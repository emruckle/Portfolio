require "application_system_test_case"

class RentalsTest < ApplicationSystemTestCase
  setup do
    @rental = rentals(:one)
  end

  test "visiting the index" do
    visit rentals_url
    assert_selector "h1", text: "Rentals"
  end

  test "should create rental" do
    visit rentals_url
    click_on "New rental"

    fill_in "Bike", with: @rental.bike_id
    fill_in "End time", with: @rental.end_time
    fill_in "Identifier", with: @rental.identifier
    check "Over time" if @rental.over_time
    fill_in "Start time", with: @rental.start_time
    fill_in "User", with: @rental.user_id
    click_on "Create Rental"

    assert_text "Rental was successfully created"
    click_on "Back"
  end

  test "should update Rental" do
    visit rental_url(@rental)
    click_on "Edit this rental", match: :first

    fill_in "Bike", with: @rental.bike_id
    fill_in "End time", with: @rental.end_time
    fill_in "Identifier", with: @rental.identifier
    check "Over time" if @rental.over_time
    fill_in "Start time", with: @rental.start_time
    fill_in "User", with: @rental.user_id
    click_on "Update Rental"

    assert_text "Rental was successfully updated"
    click_on "Back"
  end

  test "should destroy Rental" do
    visit rental_url(@rental)
    click_on "Destroy this rental", match: :first

    assert_text "Rental was successfully destroyed"
  end
end
