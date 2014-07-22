class TransactionsController < ApplicationController

  before_filter :authenticate_user!

end
