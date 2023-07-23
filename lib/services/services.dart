import 'package:gsg_quiz/api/api_methods.dart';
import 'package:gsg_quiz/api/api_url.dart';
import 'package:gsg_quiz/models/quote.dart';

class ApiService {
  Future<QuoteModel> getQuote() async {
    var data = await Api().get(url: ApiUrl.quote);
    
    return QuoteModel.fromJson(data);
  }

  Future<String> getImage(String category) async {
    
    var data = await Api().get(url:'https://random.imagecdn.app/v1/image?category=$category&format=json');
    
    return data['url'];
  }
}
