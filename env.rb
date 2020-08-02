def _bot_token
  ENV['DANONI_BOT_TOKEN'] || 'dummy'
end

def _password
  ENV['DANONI_BOT_PASSWORD'] || 'dummy'
end
