function oExample_CallbackScript(_parameter)
{
    show_message("This is a callback script.");
    
    if (_parameter != undefined)
    {
        show_message(_parameter);
    }
    else
    {
        show_message("It appears script_execute() is bugged atm");
    }
}