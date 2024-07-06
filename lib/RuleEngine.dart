
import 'package:tp3_ai_chatboot/Rule.dart';

class RuleEngine {
  final Map<String, Rule> rules;
  String currentRuleKey = 'start';

  RuleEngine() : rules = {
    'start': Rule("How i can help you , send ('auto') to start auto questions. use buttons yes ,no to quick answer", {'windFlo':'windFlo','heatwave':'heatwave','auto': 'temp', 'rain':'rain', 'snow': 'snow', 'sandstorm': 'sandstorm' ,'hot' : 'hot' // Assuming 'snow' leads directly to the 'snow' rule
}),

//'start': Rule("Is the temperature high?", {'yes': 'hot', 'no': 'cold', 'sandstorm': 'sandstorm'}),

    'temp': Rule("Is the temperature high ?", {'yes': 'hot', 'no': 'cold' ,'hot':'hot' ,'cold' :'cold'}),
    'hot': Rule("Is the wind strong?", {'yes': 'heatwave', 'no': 'hot_no_wind'}),
    'windFlo': Rule("Is the wind strong?", {'yes': 'rain', 'no': 'jsStrongCold'}),
    'jsStrongCold': Rule("Its just rain and light wind", {}),
    'cold': Rule("Is the sky cloudy?", {'yes': 'snowOrRain', 'no': 'cold_clear'}),
    'heatwave': Rule("There's a high chance of a heatwave, is wind mixed with sand ?.", {'yes':'sandstorm', 'no':'heatwave'}),
    'hot_no_wind': Rule("It's hot, but without strong wind ?", {'yes': 'clearHot', 'no': 'hotWinds'}),
    'hotWinds': Rule("It's hot winds, its sand ?.", {'yes': 'sandstorm', 'no': 'justhotWinds'}),
    'justhotWinds': Rule("It's hot winds.", {}),
    'sand': Rule("It's strong wind, its mixed with sand ?", {'yes': 'sandstorm', 'no': 'clearHot'}),
    'snowOrRain': Rule("please send snow or rain (send word) ?", {'snow': 'snow', 'rain': 'rain'}),    
    'cold_clear': Rule("It's cold, but the sky is clear.", {}),
    'snow': Rule("Expect snowfall, drive safely.", {}),
    'rain': Rule("Is it raining heavily ?", {'yes': 'heavy_rain', 'no': 'light_rain'}),
    'heavy_rain': Rule("Expect heavy rain and strong winds so possible flooding.", {}),
    'light_rain': Rule("There might be light rain, but nothing too serious.", {}),
    'sandstorm': Rule("There is a possibility of a sandstorm, but nothing too serious.", {}),
    'clearHot': Rule("There is a day clear and hot dont forget your Sun glass.", {}),
  };

String analyzeText(String input) {
    input = input.toLowerCase().trim();
    print("Analyzing text: $input"); // Debug statement

    if (input.contains('hot') && input.contains('sand') && input.contains('wind')) {
      return 'sandstorm';
    }if (input.contains('temperature') && input.contains('high')  ) {
      return 'hot';
    }
    
    if (input.contains('low') && input.contains('temperature') ) {
      return 'cold';
    }
      if (input.contains('rain') || input.contains('heavy')) {
      return 'rain';
    } 
    if (input.contains('cold')|| (input.contains('low'))) {
      return 'cold';
    } if (input.contains('snow')) {
      return 'snow';
    }  if (input.contains('rain')) {
      return 'rain';
    }  if (input.contains('auto')) {
      return 'auto';
    
    }  
    if (input.contains('flooding')) {
      return 'windFlo';
    }
    if (input.contains('sandstorm')) {
      return 'hot';
    }if (input.contains('hot') || (input.contains('high'))) {
      return 'hot';
    }


    return 'unknown';
  }

  
 String getNextStep(String currentRuleKey, String answer) {
  var rule = rules[currentRuleKey];
  if (rule != null && rule.nextSteps.containsKey(answer)) {
    return rule.nextSteps[answer] ?? 'end';  
  }
  return 'end';  
}

  String getQuestion(String ruleKey) {
    var rule = rules[ruleKey];
    if (rule != null) {
      return rule.question;
    }
    return "End of conversation.";  //  message if no rule is found.
  }

  String getConclusion() {
    switch (currentRuleKey) {
      case 'heatwave':
        return "Take precautions, a heatwave is expected.";
      case 'snow':
        return "Prepare for snow. Drive safely.";
      case 'rain':
        return "Prepare for rain. Drive safely.";
      case 'heavy_rain':
        return "Warning: Heavy rain expected. Possible flooding.";
      case 'sandstorm':
        return "Warning: sandstorm.";
          case 'sandstorm ':
        return "Warning: sandstorm.";
            case ' sandstorm ':
        return "Warning: sandstorm.";
           case 'sandstorm ':
        return "Warning: sandstorm.";
        case 'hot ':
        return "Warning: hot.";
      default:
        return "Weather conditions are stable.";
    }
  }

  void reset() {
    currentRuleKey = 'start';  
  }
}
