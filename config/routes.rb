Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'calendar.ics', to: 'calendars#ical', as: 'ical'
  get 'calendar.json', to: 'calendars#json', as: 'json'

  root to: 'pages#root'
end
