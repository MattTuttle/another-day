import js.html.XMLHttpRequest;
import yaml.Yaml;
import yaml.Parser;

class Ajax
{
	public static function getYaml(url:String, callback:Dynamic->Void, ?error:XMLHttpRequest->Void, ?beforeSend:XMLHttpRequest->Void)
	{
		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {
			if (xhr.readyState < 4 || xhr.status != 200)
			{
				if (error != null) error(xhr);
				return;
			}

			if (xhr.readyState == 4)
			{
				callback(Yaml.parse(xhr.responseText));
			}
		};
		xhr.open("GET", url, true);
		if (beforeSend != null) beforeSend(xhr);
		xhr.send();
	}
}
