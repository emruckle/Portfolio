# VectorBike

## Developed By
* Molly Neu
* Molly Daniel
* Skye Weaver Worster '25J
* Emma Ruckle
* Sydney Weisberg

## Development environment setup
VectorBike requires Ruby 3.1.2 and Rails 7.0.3.1. This guide uses MySQL for database functionality. Set up and start a MySQL database on a socket connection with a username and password.

Create a `.env` file in the repository directory, add it to your `.gitignore`, and include the following:
```
MYSQL_USERNAME=<your_username>
MYSQL_PASSWORD=<your_password>
MYSQL_SOCKET=<path_to_socket>.sock
```
For access to the Stripe API, please reach out to Sydney Weisberg for the secret key. Store the key in your `.env` file as `STRIPE_SECRET_KEY`.

Execute the following commands from your repository directory:
```rb
bundle install
rails db:reset #reconfigures the database
rails db:migrate #ensures schema is updated
rake initial_import #loads CSV data, generates pseudo-random data
rails s #launches the web server
```
Navigate to `http://localhost:3000` in a browser, and enjoy!

On each subsequent deployment, only `rails s` is required to launch the page. If changes to the schema, CSVs, or gems are made, perform all commands from `bundle install` onwards before launching.

## VectorBike MVP functionality description

### Account Management
- Users can create an account, sign in, and log out.
- On the `Profile` page, users can view and edit their information or delete their account.
- Users can add funds to their account via Stripe.
- On the `Profile` page, the user’s ride history is displayed.

### Site Navigation
- Accessible via a top navigation bar.
- Homepage includes an overview of VectorBike and a `Rent a Bike!` button linking to the rental page. `Rent` also links to the rental page.
- `About` page provides detailed information about VectorBike and an about the developers section.
- `Profile` page displays user-specific details.
- Site features a footer with contact information.

### Rental Process
- Users can access the rental page via `Rent a Bike!` on the homepage or `Rent` in the navigation bar.
- Stations are displayed in list or map view:
    - Map View: Shows station locations with clickable icons for details and directions. Searchable dropdown allows station selection. The dropdown only shows stations with at least one available bike.
    - List View: Stations sortable by name, address, or available bikes.
- Clicking a station opens a rental form to select a bike (charged > 50%) and rental duration.

### Rental Form
- Options include `Return to Stations` to cancel or `Rent Now!` to complete the rental.
- Invalid rentals (e.g., no bike selected) do not go through, and the user is shown an informative flash alert.
- Non-logged-in users are redirected to the login page before proceeding.
- If a rental is valid, and the user has enough funds, the rental goes through.

### Rental Management
- After a successful rental, users see a countdown timer and options to return the bike or view active rentals.
- Users can have up to 5 active rentals.
- The `View Bike Rentals` button lists active rentals, with links to each rental’s countdown page.

### Returning Bikes
- Users select a return station from a dropdown in a pop-up.
- Clicking `Return` processes the return, while `Close` cancels the action.
- After returning a bike, users see a success screen.

### Ride History and Metrics
- The `Profile` page lists total biking hours, and the number of rides. Ride history is also displayed.
- The top ten users with the most riding time have a badge displayed next to their name on the profile page.

### Rental Limits
- Users can have up to five active rentals.
- With at least one active rental, users are routed to the `View Bike Rentals` page when they click `Rent` or `Rent a Bike!`.
- Users with fewer than five rentals can rent additional bikes; users at the limit see a message indicating they have reached the maximum number of rentals.
- Once all rentals are returned, users are routed to the stations list when they click `Rent` or `Rent a Bike!`.

### Recommended walkthrough
- Navigate to the sign up page, and sign up for an account.
- Add funds to your account via the `Add Funds` button. We recommended putting at least $10.00 into your account. Use the card number `4242 4242 4242 4242` in the Stripe test API, provide a reasonable expiration date for the card, and fill all other fields with random data.
- Navigate to the rent page.
- Use the toggle at the top of the page to view the stations list and the embedded map/search function.
- Return to list view.
- Sort the list of stations by either name, address or number of available bikes by clicking on the corresponding part of the header.
- Select a station with at least one bike by clicking on its row (the number of available bikes is shown at the right end of each station’s row).
- In the rental form, select a bike and a duration.
- Press `Rent Now!`.
- Navigate away from the success page.
- Return to the rent page, observe it is the current rentals page rather than the station list.
- Click `Rent Another Bike` and repeat the rental process.
- Click `View Active Rentals` and observe that you now have two active rentals.
- Click on one of your rentals.
- Click the `Return Your Bike` button to start a bike return.
- Select the station you would like to return the bike to (we suggest Florence Bank station, the first station in the list when it refreshes).
- Click on `Rent` in the nav bar. Repeat the return steps to return your second rental.
- Click on a station you returned a bike to and confirm that it is once again listed in available bikes.
- Navigate to `Profile`.
- Observe that you now have two past rides.
- Click the `Delete Profile` button
- Confirm the deletion of your profile in the pop up.
