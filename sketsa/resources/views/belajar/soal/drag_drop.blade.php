<ul class="urut-list">
  @foreach ($tantangan->item as $item)
    <li class="urut" data-item-id="{{ $item->id }}" tabindex="0">
      <span class="nomor"></span>
      <span class="pegangan" aria-hidden="true">⠿</span>
      <span>{{ $item->konten }}</span>
    </li>
  @endforeach
</ul>
