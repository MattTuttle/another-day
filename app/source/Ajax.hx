import js.html.XMLHttpRequest;

class Ajax
{
	public static function get(url:String, callback:Dynamic->Void, ?error:XMLHttpRequest->Void, ?beforeSend:XMLHttpRequest->Void)
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
				callback(xhr.responseText);
			}
		};
		xhr.open("GET", url, true);
		if (beforeSend != null) beforeSend(xhr);
		xhr.send();
	}
}
