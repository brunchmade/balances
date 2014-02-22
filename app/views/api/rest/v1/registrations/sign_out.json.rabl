object @token

node(:id) { |token| token.user_id }
node(:auth_token) { |token| token.token }
