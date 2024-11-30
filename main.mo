import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

actor {
  // Otel tanımlaması
  public type Hotel = {
    name : Text;
    city : Text;
  };

  // İnceleme tanımlaması
  public type Review = {
    hotelId : Nat32;
    city : Text;
    hotelName : Text;
    rating : Nat8; // 1-5 arası
    comment : Text;
    timestamp : Int;
  };

  // Benzersiz kimlik oluşturma
  private stable var nextHotelId : Nat32 = 1;
  private stable var nextReviewId : Nat32 = 1;

  // Veri depoları
  private stable var hotels : Trie.Trie<Nat32, Hotel> = Trie.empty();
  private stable var reviews : Trie.Trie<Nat32, Review> = Trie.empty();

  // Otel oluşturma
  public func createHotel(name : Text, city : Text) : async Nat32 {
    let hotelId = nextHotelId;
    nextHotelId += 1;
    
    let newHotel : Hotel = {
      name = name;
      city = city;
    };

    hotels := Trie.replace(
      hotels,
      key(hotelId),
      Nat32.equal,
      ?newHotel
    ).0;

    return hotelId;
  };

  // İnceleme oluşturma
  public func createReview(
    hotelId : Nat32, 
    rating : Nat8, 
    comment : Text
  ) : async Nat32 {
    switch(Trie.find(hotels, key(hotelId), Nat32.equal)) {
      case(?hotel) {
        let reviewId = nextReviewId;
        nextReviewId += 1;

        let newReview : Review = {
          hotelId = hotelId;
          city = hotel.city;
          hotelName = hotel.name;
          rating = rating;
          comment = comment;
          timestamp = Time.now();
        };

        reviews := Trie.replace(
          reviews,
          key(reviewId),
          Nat32.equal,
          ?newReview
        ).0;

        return reviewId;
      };
      case(null) return 0;
    };
  };

  // Bir otele ait tüm incelemeleri getir
  public query func getHotelReviews(hotelId : Nat32) : async [Review] {
    var hotelReviews : [Review] = [];
    
    for ((id, review) in Trie.iter(reviews)) {
      if (review.hotelId == hotelId) {
        hotelReviews := Array.append(hotelReviews, [review]);
      };
    };

    return hotelReviews;
  };

  // Test fonksiyonu
  public func runTest() : async () {
    Debug.print("Test başlatılıyor...");

    // İstanbul'da bir otel oluştur
    let hotelId = await createHotel("Hilton Istanbul", "İstanbul");
    Debug.print("Otel oluşturuldu. ID: " # debug_show(hotelId));

    // Oteli puanla ve yorum yaz
    let reviewId = await createReview(
      hotelId, 
      5, 
      "Muhteşem bir otel, kesinlikle tavsiye ediyorum!"
    );
    Debug.print("Review oluşturuldu. ID: " # debug_show(reviewId));

    // Otelin tüm yorumlarını görüntüle
    let hotelReviews = await getHotelReviews(hotelId);
    Debug.print("Review sayısı: " # debug_show(hotelReviews.size()));
  };

  // Kimlik için yardımcı fonksiyon
  private func key(x : Nat32) : Trie.Key<Nat32> {
    return { hash = x; key = x };
  };
}
