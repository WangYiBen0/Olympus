using System.Collections.Generic;

namespace Olympus {
    // Lang.Get just looks nicer than CmdSetLanguageMap.GetLangEntry
    public class Lang {
        public static string Get(string key) => CmdSetLanguageMap.GetLangEntry(key);
    }

    public class CmdSetLanguageMap : Cmd<string, string, string> {
        private static readonly Dictionary<string, string> languageMap = new Dictionary<string, string>();
        public static string GetLangEntry(string key) => languageMap[key];

        public override string Run(string key, string value) {
            languageMap[key["csharp_".Length ..]] = value;
            return "ok";
        }
    }
}
