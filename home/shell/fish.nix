{ ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
      starship_transient_prompt_func = "starship module character";
    };
  };

  programs.starship.enableFishIntegration = true;
  programs.starship.enableTransience = true;
  programs.fzf.enableFishIntegration = true;
  
}
