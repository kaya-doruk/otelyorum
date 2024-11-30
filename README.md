# Otel ve İnceleme Sistemi (Motoko)

Bu proje, bir otel oluşturma ve otellere yorum yapma işlemlerini gerçekleştiren bir sistemdir. Kullanıcılar otel oluşturabilir, otellere puan verebilir ve yorum yazabilir. Sistemde her otel için benzersiz bir kimlik (`hotelId`) oluşturulur, her yorum için de benzersiz bir kimlik (`reviewId`) atanır.

## Özellikler

- **Otel Oluşturma**: Kullanıcılar, şehir ve isim bilgilerini girerek yeni oteller oluşturabilir.
- **Yorum Yapma**: Kullanıcılar, oluşturulmuş bir otele puan (1-5 arasında) verebilir ve yorum yazabilir.
- **Otel Yorumlarını Görüntüleme**: Kullanıcılar, bir otel için yapılmış olan tüm yorumları görebilir.

## Teknolojiler

- **Motoko**: Bu sistem, Dfinity'nin Motoko programlama dili ile yazılmıştır.
- **Trie Veri Yapısı**: Oteller ve yorumlar, hızlı erişim ve güncelleme için `Trie` veri yapısında depolanmaktadır.

## Kurulum

### Motoko Playground

Bu proje, Motoko Playground'da çalıştırılabilir. Aşağıdaki adımları takip ederek projeyi çalıştırabilirsiniz:

1. [Motoko Playground](https://m7sm4-2iaaa-aaaab-aaanq-cai.ic0.app/) sayfasını açın.
2. Yukarıdaki kodu kopyalayın ve Playground'da yeni bir aktör (`actor`) dosyasına yapıştırın.
3. Kodun hemen altında bulunan `runTest` fonksiyonunu çalıştırarak testi başlatın.

## Kullanım

### 1. Otel Oluşturma

`createHotel(name: Text, city: Text)` fonksiyonu, bir otel oluşturmak için kullanılır. Bu fonksiyon, otelin adını ve şehrini parametre olarak alır ve otel oluşturulduktan sonra benzersiz bir `hotelId` döndürür.

```motoko
let hotelId = await createHotel("Hilton Istanbul", "İstanbul");
