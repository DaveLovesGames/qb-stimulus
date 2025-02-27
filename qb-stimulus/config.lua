Config = {}

-- Command settings
Config.Command = "stimulus" -- The command to run the stimulus payment

-- Messages
Config.Messages = {
    NoPermission = "You don't have permission to use this command.",
    InvalidArgs = "Invalid arguments. Use /%s [player/business] [amount]",
    InvalidType = "Invalid type. Use 'player' or 'business'",
    InvalidAmount = "Invalid amount. Please enter a valid number.",
    Success = "Successfully distributed $%s to all %s accounts.",
    Error = "An error occurred while processing the stimulus payment."
} 