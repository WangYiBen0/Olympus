using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace Olympus {
    // Lang.Get just looks nicer than CmdSetLanguageMap.GetLangEntry
    public class Lang {
        public static string Get(string key) => CmdSetLanguageMap.GetLangEntry(key);
    }

    public class CmdSetLanguageMap : Cmd<string, string> {
        private static readonly Dictionary<string, string> languageMap = new Dictionary<string, string>();
        public static string GetLangEntry(string key) => languageMap[key];

        public override string Run(string csharpKeysJson) {
            // since we can't pass an array through the lua-sharp bridge, we're passing JSON instead
            // and now we need to parse it! :destareline:
            JObject csharpKeys = JObject.Parse(csharpKeysJson);
            languageMap.Clear();
            foreach (KeyValuePair<string, JToken> entry in csharpKeys) {
                languageMap.Add(entry.Key["csharp_".Length ..], entry.Value.ToObject<string>());
            }
            return "ok";
        }
    }
}
